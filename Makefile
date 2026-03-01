TARGET ?= Popcorn
TEST_TARGET ?= PopcornTests
TEST_PLAN ?= PopcornUnitTests
SCHEME ?= $(TARGET)
PLATFORM ?= ios
DESTINATION ?= 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.2'
DESTINATION_MACOS ?= 'platform=macOS'
SNAPSHOT_TEST_PLAN ?= PopcornSnapshotTests
UI_TEST_PLAN ?= PopcornUITests
DERIVED_DATA ?= DerivedData
RESULT_BUNDLE ?= $(DERIVED_DATA)/Result.xcresult
CLEAN ?= 0
ENV_FILE ?= .env

# Load env vars if a local .env (or custom ENV_FILE) exists; ignored if absent.
-include $(ENV_FILE)

XCODEBUILD = set -o pipefail && NSUnbufferedIO=YES xcodebuild
XCODEBUILD_FLAGS = -scheme $(SCHEME) -destination $(DESTINATION) -parallelizeTargets
XCODEBUILD_FLAGS_MACOS = -scheme $(SCHEME) -destination $(DESTINATION_MACOS) -parallelizeTargets

.PHONY: clean
clean:
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1

.PHONY: clean-spm
clean-spm:
	@echo Deleting .build directories...
	@find . -type d -name ".build" -prune -exec rm -rf {} + 2>/dev/null || true
	@echo Deleting .spm directories...
	@find . -type d -name ".spm" -prune -exec rm -rf {} + 2>/dev/null || true
	@echo Deleting .swiftpm directories...
	@find . -type d -name ".swiftpm" -prune -exec rm -rf {} + 2>/dev/null || true

.PHONY: format
format: clean-spm
	@swiftlint --fix .
	@swiftformat .

.PHONY: lint format-check
lint format-check: clean-spm
	@swiftlint --strict .
	@swiftformat --lint .

.PHONY: build
build:
	rm -rf $(RESULT_BUNDLE)
ifneq ($(CLEAN),0)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1
endif
	$(XCODEBUILD) build $(XCODEBUILD_FLAGS) 2>&1

.PHONY: build-for-testing
build-for-testing:
ifneq ($(CLEAN),0)
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1
endif
	$(XCODEBUILD) build-for-testing $(XCODEBUILD_FLAGS) -testPlan $(TEST_PLAN) 2>&1

.PHONY: test
test:
ifneq ($(CLEAN),0)
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1
endif
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) build-for-testing $(XCODEBUILD_FLAGS) -testPlan $(TEST_PLAN) 2>&1
	$(XCODEBUILD) test-without-building $(XCODEBUILD_FLAGS) -testPlan $(TEST_PLAN) 2>&1

.PHONY: build-macos
build-macos:
	rm -rf $(RESULT_BUNDLE)
ifneq ($(CLEAN),0)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1
endif
	$(XCODEBUILD) build $(XCODEBUILD_FLAGS_MACOS) 2>&1

.PHONY: build-for-testing-macos
build-for-testing-macos:
ifneq ($(CLEAN),0)
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1
endif
	$(XCODEBUILD) build-for-testing $(XCODEBUILD_FLAGS_MACOS) -testPlan $(TEST_PLAN) 2>&1

.PHONY: test-macos
test-macos:
ifneq ($(CLEAN),0)
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1
endif
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) build-for-testing $(XCODEBUILD_FLAGS_MACOS) -testPlan $(TEST_PLAN) 2>&1
	$(XCODEBUILD) test-without-building $(XCODEBUILD_FLAGS_MACOS) -testPlan $(TEST_PLAN) 2>&1

# Usage:
#   make test-snapshots                                                                        — run all snapshot tests
#   make test-snapshots TEST_CLASS=ExploreFeatureSnapshotTests/ExploreViewTests                 — run all tests in a test class
#   make test-snapshots TEST_CLASS=ExploreFeatureSnapshotTests/ExploreViewTests/testSnapshot    — run a single test
.PHONY: test-snapshots
test-snapshots:
ifneq ($(CLEAN),0)
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1
endif
	rm -rf $(RESULT_BUNDLE)
ifdef TEST_CLASS
	$(XCODEBUILD) build-for-testing $(XCODEBUILD_FLAGS) -testPlan $(SNAPSHOT_TEST_PLAN) 2>&1
	$(XCODEBUILD) test-without-building $(XCODEBUILD_FLAGS) -testPlan $(SNAPSHOT_TEST_PLAN) -only-testing $(TEST_CLASS) 2>&1
else
	$(XCODEBUILD) build-for-testing $(XCODEBUILD_FLAGS) -testPlan $(SNAPSHOT_TEST_PLAN) 2>&1
	$(XCODEBUILD) test-without-building $(XCODEBUILD_FLAGS) -testPlan $(SNAPSHOT_TEST_PLAN) 2>&1
endif

# Usage:
#   make test-ui                                          — run all UI tests
#   make test-ui TEST_CLASS=PopcornUITests/ExploreTests   — run all tests in a test class
#   make test-ui TEST_CLASS=PopcornUITests/ExploreTests/testLaunch — run a single test
.PHONY: test-ui
test-ui:
ifneq ($(CLEAN),0)
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1
endif
	rm -rf $(RESULT_BUNDLE)
ifdef TEST_CLASS
	$(XCODEBUILD) build-for-testing $(XCODEBUILD_FLAGS) -testPlan $(UI_TEST_PLAN) 2>&1
	$(XCODEBUILD) test-without-building $(XCODEBUILD_FLAGS) -testPlan $(UI_TEST_PLAN) -only-testing $(TEST_CLASS) 2>&1
else
	$(XCODEBUILD) build-for-testing $(XCODEBUILD_FLAGS) -testPlan $(UI_TEST_PLAN) 2>&1
	$(XCODEBUILD) test-without-building $(XCODEBUILD_FLAGS) -testPlan $(UI_TEST_PLAN) 2>&1
endif
