TARGET ?= Popcorn
TEST_TARGET ?= PopcornTests
TEST_PLAN ?= PopcornUnitTests
SCHEME ?= $(TARGET)
PLATFORM ?= ios
DESTINATION ?= 'platform=iOS Simulator,name=iPhone 17,OS=26.2'
DERIVED_DATA ?= DerivedData
RESULT_BUNDLE ?= $(DERIVED_DATA)/Result.xcresult
CLEAN ?= 0
ENV_FILE ?= .env

# Load env vars if a local .env (or custom ENV_FILE) exists; ignored if absent.
-include $(ENV_FILE)

XCODEBUILD = set -o pipefail && NSUnbufferedIO=YES xcodebuild
XCODEBUILD_FLAGS = -scheme $(SCHEME) -destination $(DESTINATION) -parallelizeTargets
XCSIFT = xcsift -f toon
XCSIFT_BUILD = $(XCSIFT) --Werror

.PHONY: clean
clean:
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1 | $(XCSIFT)

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
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1 | $(XCSIFT)
endif
	$(XCODEBUILD) build $(XCODEBUILD_FLAGS) 2>&1 | $(XCSIFT_BUILD)

.PHONY: build-for-testing
build-for-testing:
ifneq ($(CLEAN),0)
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1 | $(XCSIFT)
endif
	$(XCODEBUILD) build-for-testing $(XCODEBUILD_FLAGS) -testPlan $(TEST_PLAN) 2>&1 | $(XCSIFT_BUILD)

.PHONY: test
test:
ifneq ($(CLEAN),0)
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME) 2>&1 | $(XCSIFT)
endif
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) build-for-testing $(XCODEBUILD_FLAGS) -only-testing $(TEST_TARGET) 2>&1 | $(XCSIFT_BUILD)
	$(XCODEBUILD) test-without-building $(XCODEBUILD_FLAGS) -only-testing $(TEST_TARGET) 2>&1 | $(XCSIFT)

.PHONY: build-ios
build-ios:
	$(XCODEBUILD) build $(XCODEBUILD_FLAGS) PLATFORM=ios DESTINATION='$(DESTINATION)' 2>&1 | $(XCSIFT_BUILD)

.PHONY: test-ios
test-ios:
	$(XCODEBUILD) test $(XCODEBUILD_FLAGS) PLATFORM=ios DESTINATION='$(DESTINATION)' 2>&1 | $(XCSIFT)
