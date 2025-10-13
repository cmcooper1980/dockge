<template>
    <div class="shadow-box mb-3" :style="boxStyle">
        <div class="list-header">
            <div class="header-top">
                <!-- TODO -->
                <button v-if="false" class="btn btn-outline-normal ms-2" :class="{ 'active': selectMode }" type="button"
                    @click="selectMode = !selectMode">
                    {{ $t("Select") }}
                </button>

                <div class="placeholder"></div>

                <div class="search-wrapper">
                    <a v-if="searchText == ''" class="search-icon">
                        <font-awesome-icon icon="search" />
                    </a>
                    <a v-if="searchText != ''" class="search-icon" style="cursor: pointer" @click="clearSearchText">
                        <font-awesome-icon icon="times" />
                    </a>
                    <form>
                        <input v-model="searchText" class="form-control search-input" autocomplete="off" />
                    </form>
                </div>

                <div class="update-all-wrapper">
                    <button class="btn btn-primary" :disabled="processing || flatStackList.length === 0" @click="updateAll">
                        <font-awesome-icon icon="fa-cloud-arrow-down me-1" />
                        {{ $t("updateAll") }}
                    </button>
                </div>
            </div>

            <!-- TODO -->
            <div v-if="false" class="header-filter">
                <!--<StackListFilter :filterState="filterState" @update-filter="updateFilter" />-->
            </div>

            <!-- TODO: Selection Controls -->
            <div v-if="selectMode && false" class="selection-controls px-2 pt-2">
                <input v-model="selectAll" class="form-check-input select-input" type="checkbox" />

                <button class="btn-outline-normal" @click="pauseDialog">
                    <font-awesome-icon icon="pause" size="sm" /> {{ $t("Pause") }}
                </button>
                <button class="btn-outline-normal" @click="resumeSelected">
                    <font-awesome-icon icon="play" size="sm" /> {{ $t("Resume") }}
                </button>

                <span v-if="selectedStackCount > 0">
                    {{ $t("selectedStackCount", [selectedStackCount]) }}
                </span>
            </div>
        </div>

        <div ref="stackList" class="stack-list" :class="{ scrollbar: scrollbar }" :style="stackListStyle">
            <div v-if="flatStackList.length === 0" class="text-center mt-3">
                <router-link to="/compose">{{ $t("addFirstStackMsg") }}</router-link>
            </div>

            <div class="stack-list-inner" v-for="(agent, index) in agentStackList" :key="index">
                <div v-if="$root.agentCount > 1"
                     class="p-2 agent-select"
                     @click="closedAgents.set(agent.endpoint, !closedAgents.get(agent.endpoint))">
                    <span class="me-1">
                        <font-awesome-icon v-show="closedAgents.get(agent.endpoint)" icon="chevron-circle-right" />
                        <font-awesome-icon v-show="!closedAgents.get(agent.endpoint)" icon="chevron-circle-down" />
                    </span>
                    <span v-if="agent.endpoint === 'current'">{{ $t("currentEndpoint") }}</span>
                    <span v-else>{{ agent.endpoint }}</span>
                </div>

                <StackListItem
                    v-show="$root.agentCount === 1 || !closedAgents.get(agent.endpoint)"
                    v-for="(item, i) in agent.stacks"
                    :key="i"
                    :stack="item"
                    :isSelectMode="selectMode"
                    :isSelected="isSelected"
                    :select="select"
                    :deselect="deselect"
                />
            </div>
        </div>
    </div>

    <Confirm ref="confirmPause" :yes-text="$t('Yes')" :no-text="$t('No')" @yes="pauseSelected">
        {{ $t("pauseStackMsg") }}
    </Confirm>
</template>

<script>
import Confirm from "../components/Confirm.vue";
import StackListItem from "../components/StackListItem.vue";
import { CREATED_FILE, CREATED_STACK, EXITED, RUNNING, UNKNOWN } from "../../../common/util-common";

export default {
    components: { Confirm, StackListItem },
    props: {
        scrollbar: { type: Boolean },
    },
    data() {
        return {
            searchText: "",
            selectMode: false,
            selectAll: false,
            disableSelectAllWatcher: false,
            selectedStacks: {},
            windowTop: 0,
            filterState: { status: null, active: null, tags: null },
            closedAgents: new Map(),
            processing: false,
        };
    },
    computed: {
        boxStyle() {
            if (window.innerWidth > 550) {
                return { height: `calc(100vh - 160px + ${this.windowTop}px)` };
            } else {
                return { height: "calc(100vh - 160px)" };
            }
        },
        /** Grouped stacks (PR #800 behavior), with filters + sort applied */
        agentStackList() {
            let result = Object.values(this.$root.completeStackList);

            // filter
            result = result.filter(stack => {
                // search text
                let searchTextMatch = true;
                if (this.searchText !== "") {
                    const lowered = this.searchText.toLowerCase();
                    searchTextMatch =
                        stack.name.toLowerCase().includes(lowered) ||
                        stack.tags.find(tag =>
                            tag.name.toLowerCase().includes(lowered) ||
                            tag.value?.toLowerCase().includes(lowered)
                        );
                }

                // active filter
                let activeMatch = true;
                if (this.filterState.active != null && this.filterState.active.length > 0) {
                    activeMatch = this.filterState.active.includes(stack.active);
                }

                // tags filter
                let tagsMatch = true;
                if (this.filterState.tags != null && this.filterState.tags.length > 0) {
                    tagsMatch = stack.tags
                        .map(tag => tag.tag_id)
                        .filter(id => this.filterState.tags.includes(id))
                        .length > 0;
                }

                return searchTextMatch && activeMatch && tagsMatch;
            });

            // sort
            result.sort((m1, m2) => {
                if (m1.isManagedByDockge && !m2.isManagedByDockge) return -1;
                if (!m1.isManagedByDockge && m2.isManagedByDockge) return 1;

                if (m1.status !== m2.status) {
                    if (m2.status === RUNNING) return 1;
                    if (m1.status === RUNNING) return -1;
                    if (m2.status === EXITED) return 1;
                    if (m1.status === EXITED) return -1;
                    if (m2.status === CREATED_STACK) return 1;
                    if (m1.status === CREATED_STACK) return -1;
                    if (m2.status === CREATED_FILE) return 1;
                    if (m1.status === CREATED_FILE) return -1;
                    if (m2.status === UNKNOWN) return 1;
                    if (m1.status === UNKNOWN) return -1;
                }
                return m1.name.localeCompare(m2.name);
            });

            // group by endpoint with 'current' first, others alphabetical
            const groups = [
                ...result.reduce((acc, stack) => {
                    const endpoint = stack.endpoint || 'current';
                    if (!acc.has(endpoint)) acc.set(endpoint, []);
                    acc.get(endpoint).push(stack);
                    return acc;
                }, new Map()).entries()
            ].map(([endpoint, stacks]) => ({ endpoint, stacks }));

            groups.sort((a, b) => {
                if (a.endpoint === 'current' && b.endpoint !== 'current') return -1;
                if (a.endpoint !== 'current' && b.endpoint === 'current') return 1;
                return a.endpoint.localeCompare(b.endpoint);
            });

            return groups;
        },
        /** flat list for convenience (button states, updateAll, selection watchers) */
        flatStackList() {
            return this.agentStackList.flatMap(g => g.stacks);
        },
        isDarkTheme() {
            return document.body.classList.contains("dark");
        },
        stackListStyle() {
            let listHeaderHeight = 60;
            if (this.selectMode) listHeaderHeight += 42;
            return { height: `calc(100% - ${listHeaderHeight}px)` };
        },
        selectedStackCount() {
            return Object.keys(this.selectedStacks).length;
        },
        filtersActive() {
            return this.filterState.status != null ||
                   this.filterState.active != null ||
                   this.filterState.tags != null ||
                   this.searchText !== "";
        }
    },
    watch: {
        searchText() {
            for (let stack of this.flatStackList) {
                if (!this.selectedStacks[stack.id]) {
                    if (this.selectAll) {
                        this.disableSelectAllWatcher = true;
                        this.selectAll = false;
                    }
                    break;
                }
            }
        },
        selectAll() {
            if (!this.disableSelectAllWatcher) {
                this.selectedStacks = {};
                if (this.selectAll) {
                    this.flatStackList.forEach((item) => {
                        this.selectedStacks[item.id] = true;
                    });
                }
            } else {
                this.disableSelectAllWatcher = false;
            }
        },
        selectMode() {
            if (!this.selectMode) {
                this.selectAll = false;
                this.selectedStacks = {};
            }
        },
    },
    mounted() {
        window.addEventListener("scroll", this.onScroll);
    },
    beforeUnmount() {
        window.removeEventListener("scroll", this.onScroll);
    },
    methods: {
        onScroll() {
            if (window.top.scrollY <= 133) {
                this.windowTop = window.top.scrollY;
            } else {
                this.windowTop = 133;
            }
        },
        clearSearchText() {
            this.searchText = "";
        },
        updateFilter(newFilter) {
            this.filterState = newFilter;
        },
        deselect(id) {
            delete this.selectedStacks[id];
        },
        select(id) {
            this.selectedStacks[id] = true;
        },
        isSelected(id) {
            return id in this.selectedStacks;
        },
        cancelSelectMode() {
            this.selectMode = false;
            this.selectedStacks = {};
        },
        pauseDialog() {
            this.$refs.confirmPause.show();
        },
        pauseSelected() {
            Object.keys(this.selectedStacks)
                .filter(id => this.$root.stackList[id].active)
                .forEach(id => this.$root.getSocket().emit("pauseStack", id, () => {}));
            this.cancelSelectMode();
        },
        resumeSelected() {
            Object.keys(this.selectedStacks)
                .filter(id => !this.$root.stackList[id].active)
                .forEach(id => this.$root.getSocket().emit("resumeStack", id, () => {}));
            this.cancelSelectMode();
        },
        updateAll() {
            this.processing = true;
            for (let stack of this.flatStackList) {
                this.$root.emitAgent(stack.endpoint, "updateStack", stack.name, (res) => {
                    this.processing = false;
                    this.$root.toastRes(res);
                });
            }
        },
    },
};
</script>

<style lang="scss" scoped>
@import "../styles/vars.scss";

.shadow-box {
    height: calc(100vh - 150px);
    position: sticky;
    top: 10px;
}

.small-padding {
    padding-left: 5px !important;
    padding-right: 5px !important;
}

.list-header {
    border-bottom: 1px solid #dee2e6;
    border-radius: 10px 10px 0 0;
    margin: -10px;
    margin-bottom: 10px;
    padding: 10px;

    .dark & {
        background-color: $dark-header-bg;
        border-bottom: 0;
    }
}

.header-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.header-filter {
    display: flex;
    align-items: center;
}

@media (max-width: 770px) {
    .list-header {
        margin: -20px;
        margin-bottom: 10px;
        padding: 5px;
    }
}

.search-wrapper {
    display: flex;
    align-items: center;
}

.search-icon {
    padding: 10px;
    color: #c0c0c0;

    // Clear filter button (X)
    svg[data-icon="times"] {
        cursor: pointer;
        transition: all ease-in-out 0.1s;

        &:hover {
            opacity: 0.5;
        }
    }
}

.search-input {
    max-width: 10em;
}

.stack-item {
    width: 100%;
}

.tags {
    margin-top: 4px;
    padding-left: 67px;
    display: flex;
    flex-wrap: wrap;
    gap: 0;
}

.bottom-style {
    padding-left: 67px;
    margin-top: 5px;
}

.selection-controls {
    margin-top: 5px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.agent-select {
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    color: $dark-font-color3;
    padding-left: 10px;
    padding-right: 10px;
    display: flex;
    align-items: center;
    user-select: none;
}
</style>
