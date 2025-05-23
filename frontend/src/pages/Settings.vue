<template>
    <div>
        <h1 v-show="show" class="mb-3">
            {{ $t("Settings") }}
        </h1>

        <div class="shadow-box shadow-box-settings">
            <div class="row">
                <div v-if="showSubMenu" class="settings-menu col-lg-3 col-md-5">
                    <router-link
                        v-for="(item, key) in subMenus"
                        :key="key"
                        :to="`/settings/${key}`"
                    >
                        <div class="menu-item">
                            {{ item.title }}
                        </div>
                    </router-link>

                    <!-- Logout Button -->
                    <a v-if="$root.isMobile && $root.loggedIn && $root.socket.token !== 'autoLogin'" class="logout" @click.prevent="$root.logout">
                        <div class="menu-item">
                            <font-awesome-icon icon="sign-out-alt" />
                            {{ $t("Logout") }}
                        </div>
                    </a>
                </div>
                <div class="settings-content col-lg-9 col-md-7">
                    <div v-if="currentPage" class="settings-content-header">
                        {{ subMenus[currentPage].title }}
                    </div>
                    <div class="mx-3">
                        <router-view v-slot="{ Component }">
                            <transition name="slide-fade" appear>
                                <component :is="Component" />
                            </transition>
                        </router-view>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { useRoute } from "vue-router";

export default {
    data() {
        return {
            show: true,
            settings: {},
            settingsLoaded: false,
        };
    },

    computed: {
        currentPage() {
            let pathSplit = useRoute().path.split("/");
            let pathEnd = pathSplit[pathSplit.length - 1];
            if (!pathEnd || pathEnd === "settings") {
                return null;
            }
            return pathEnd;
        },

        showSubMenu() {
            if (this.$root.isMobile) {
                return !this.currentPage;
            } else {
                return true;
            }
        },

        subMenus() {
            return {
                general: {
                    title: this.$t("general"),
                },
                appearance: {
                    title: this.$t("Appearance"),
                },
                security: {
                    title: this.$t("Security"),
                },
                globalEnv: {
                    title: this.$t("GlobalEnv"),
                },
                about: {
                    title: this.$t("About"),
                },
            };
        },
    },

    watch: {
        "$root.isMobile"() {
            this.loadGeneralPage();
        }
    },

    mounted() {
        this.loadSettings();
        this.loadGeneralPage();
    },

    methods: {

        /**
         * Load the general settings page
         * For desktop only, on mobile do nothing
         */
        loadGeneralPage() {
            if (!this.currentPage && !this.$root.isMobile) {
                this.$router.push("/settings/appearance");
            }
        },

        /** Load settings from server */
        loadSettings() {
            this.$root.getSocket().emit("getSettings", (res) => {
                this.settings = res.data;
                if (this.settings.checkUpdate === undefined) {
                    this.settings.checkUpdate = true;
                }
                this.settingsLoaded = true;
            });
        },

        /**
         * Callback for saving settings
         * @callback saveSettingsCB
         * @param {Object} res Result of operation
         */

        /**
         * Save Settings
         * @param {saveSettingsCB} [callback]
         * @param {string} [currentPassword] Only need for disableAuth to true
         */
        saveSettings(callback, currentPassword) {
            let valid = this.validateSettings();
            if (valid.success) {
                this.$root.getSocket().emit("setSettings", this.settings, currentPassword, (res) => {
                    this.$root.toastRes(res);
                    this.loadSettings();

                    if (callback) {
                        callback();
                    }
                });
            } else {
                this.$root.toastError(valid.msg);
            }
        },

        /**
         * Ensure settings are valid
         * @returns {Object} Contains success state and error msg
         */
        validateSettings() {
            if (this.settings.keepDataPeriodDays < 0) {
                return {
                    success: false,
                    msg: this.$t("dataRetentionTimeError"),
                };
            }
            return {
                success: true,
                msg: "",
            };
        },
    }
};
</script>

<style lang="scss" scoped>
@import "../styles/vars.scss";

.shadow-box-settings {
    padding: 20px;
    min-height: calc(100vh - 155px);
}

footer {
    color: #aaa;
    font-size: 13px;
    margin-top: 20px;
    padding-bottom: 30px;
    text-align: center;
}

.settings-menu {
    a {
        text-decoration: none !important;
    }

    .menu-item {
        border-radius: 10px;
        margin: 0.5em;
        padding: 0.7em 1em;
        cursor: pointer;
        border-left-width: 0;
        transition: all ease-in-out 0.1s;
    }

    .menu-item:hover {
        background: $highlight-white;

        .dark & {
            background: $dark-header-bg;
        }
    }

    .active .menu-item {
        background: $highlight-white;
        border-left: 4px solid $primary;
        border-top-left-radius: 0;
        border-bottom-left-radius: 0;

        .dark & {
            background: $dark-header-bg;
        }
    }
}

.settings-content {
    .settings-content-header {
        width: calc(100% + 20px);
        border-bottom: 1px solid #dee2e6;
        border-radius: 0 10px 0 0;
        margin-top: -20px;
        margin-right: -20px;
        padding: 12.5px 1em;
        font-size: 26px;

        .dark & {
            background: $dark-header-bg;
            border-bottom: 0;
        }

        .mobile & {
            padding: 15px 0 0 0;

            .dark & {
                background-color: transparent;
            }
        }
    }
}

.logout {
    color: $danger !important;
}
</style>
