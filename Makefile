TARGET ?= Popcorn
TEST_TARGET ?= PopcornTests
SCHEME ?= $(TARGET)
PLATFORM ?= ios
DESTINATION ?= 'platform=iOS Simulator,name=iPhone 17,OS=26.2'
DERIVED_DATA ?= DerivedData
RESULT_BUNDLE ?= $(DERIVED_DATA)/Result.xcresult
CLEAN ?= 0
ENV_FILE ?= .env

# Load env vars if a local .env (or custom ENV_FILE) exists; ignored if absent.
-include $(ENV_FILE)

XCODEBUILD = set -o pipefail && NSUnbufferedIO=YES IDEBuildOperationMaxNumberOfConcurrentCompileTasks=9 xcodebuild
XCODEBUILD_FLAGS = -scheme $(SCHEME) -derivedDataPath $(DERIVED_DATA) -resultBundlePath $(RESULT_BUNDLE) -destination $(DESTINATION) -parallelizeTargets

.PHONY: clean
clean:
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME)

.PHONY: format
format:
	@swift format -r -p -i .

.PHONY: lint format-check
lint format-check:
	@swift format lint -r -p --strict .

.PHONY: build
build:
ifneq ($(CLEAN),0)
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME)
endif
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) build $(XCODEBUILD_FLAGS)

.PHONY: test
test:
ifneq ($(CLEAN),0)
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME)
endif
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) build-for-testing $(XCODEBUILD_FLAGS) -only-testing $(TEST_TARGET)
	$(XCODEBUILD) test-without-building $(XCODEBUILD_FLAGS) -only-testing $(TEST_TARGET)

.PHONY: build-ios
build-ios:
	$(MAKE) build PLATFORM=ios DESTINATION='platform=iOS Simulator,name=iPhone 17,OS=26.1'

.PHONY: test-ios
test-ios:
	$(MAKE) test PLATFORM=ios DESTINATION='platform=iOS Simulator,name=iPhone 17,OS=26.1'
