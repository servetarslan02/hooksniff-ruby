# frozen_string_literal: true
# This file is @generated
require "json"

module HookSniff
  class EventTypeImportOpenApiIn
    # If `true`, return the event types that would be modified without actually modifying them.
    attr_accessor :dry_run
    # If `true`, all existing event types that are not in the spec will be archived.
    attr_accessor :replace_all
    # A pre-parsed JSON spec.
    attr_accessor :spec
    # A string, parsed by the server as YAML or JSON.
    attr_accessor :spec_raw

    ALL_FIELD ||= [
      "dry_run",
      "replace_all",
      "spec",
      "spec_raw"
    ].freeze
    private_constant :ALL_FIELD

    def initialize(attributes = {})
      unless attributes.is_a?(Hash)
        fail(ArgumentError, "The input argument (attributes) must be a hash in `HookSniff::EventTypeImportOpenApiIn` new method")
      end

      attributes.each do |k, v|
        unless ALL_FIELD.include?(k.to_s)
          fail(ArgumentError, "The field #{k} is not part of HookSniff::EventTypeImportOpenApiIn")
        end

        instance_variable_set("@#{k}", v)
        instance_variable_set("@__#{k}_is_defined", true)
      end
    end

    def self.deserialize(attributes = {})
      attributes = attributes.transform_keys(&:to_s)
      attrs = Hash.new
      attrs["dry_run"] = attributes["dryRun"]
      attrs["replace_all"] = attributes["replaceAll"]
      attrs["spec"] = attributes["spec"]
      attrs["spec_raw"] = attributes["specRaw"]
      new(attrs)
    end

    def serialize
      out = Hash.new
      out["dryRun"] = HookSniff::serialize_primitive(@dry_run) unless @dry_run.nil?
      out["replaceAll"] = HookSniff::serialize_primitive(@replace_all) unless @replace_all.nil?
      out["spec"] = HookSniff::serialize_primitive(@spec) if @spec
      out["specRaw"] = HookSniff::serialize_primitive(@spec_raw) if @spec_raw
      out
    end

    def to_json
      JSON.dump(serialize)
    end
  end
end
