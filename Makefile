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

XCODEBUILD = set -o pipefail && NSUnbufferedIO=YES xcodebuild
XCODEBUILD_FLAGS = -scheme $(SCHEME) -destination $(DESTINATION) -parallelizeTargets

.PHONY: clean
clean:
	rm -rf $(RESULT_BUNDLE)
	$(XCODEBUILD) clean -scheme $(SCHEME)

.PHONY: clean-spm
clean-spm:
	find . -type d -name ".build" -prune -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".spm" -prune -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".swiftpm" -prune -exec rm -rf {} + 2>/dev/null || true

.PHONY: format
format:
	@swiftlint --fix .
	@swiftformat .

.PHONY: lint format-check
lint format-check:
	@swiftlint --strict .
	@swiftformat --lint .

.PHONY: build
build:
	rm -rf $(RESULT_BUNDLE)
ifneq ($(CLEAN),0)
	$(XCODEBUILD) clean -scheme $(SCHEME)
endif
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
	$(XCODEBUILD) build $(XCODEBUILD_FLAGS) PLATFORM=ios DESTINATION='$(DESTINATION)'

.PHONY: test-ios
test-ios:
	$(XCODEBUILD) test $(XCODEBUILD_FLAGS) PLATFORM=ios DESTINATION='$(DESTINATION)'
