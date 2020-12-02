module RunLoop

  # @!visibility private
  module Regex

    # @!visibility private
    CORE_SIMULATOR_UDID_REGEX = /[A-F0-9]{8}-([A-F0-9]{4}-){3}[A-F0-9]{12}/.freeze

    # @!visibility private
    XCODE_511_SIMULATOR_REGEX = /(\d)\.(\d)\.?(\d)?(-64)?/.freeze

    # @!visibility private
    DEVICE_UDID_REGEX = /[a-f0-9]{40}|([A-F0-9]{8}-[A-F0-9]{16})/.freeze

    # @!visibility private
    VERSION_REGEX = /(\d+\.\d+(\.\d+)?)/.freeze

    # @!visibility private
    XCODE_102_SIMULATOR_REGEX = /(?<version>\d+(-\d){1,2}\z)/.freeze

  end
end
