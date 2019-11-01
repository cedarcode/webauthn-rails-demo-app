# frozen_string_literal: true

class Credential < ApplicationRecord
  UNSAFE_STATUSES = [
    "USER_VERIFICATION_BYPASS",
    "ATTESTATION_KEY_COMPROMISE",
    "USER_KEY_REMOTE_COMPROMISE",
    "USER_KEY_PHYSICAL_COMPROMISE",
    "REVOKED",
  ].freeze

  validates :external_id, :public_key, :nickname, :sign_count, presence: true
  validates :external_id, uniqueness: true
  validates :sign_count,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2**32 - 1 }
  validates :aaguid, :u2f_key_id, absence:true, if: -> { aaguid && u2f_key_id }

  def self.unsafe_status?(status_reports)
    # This is a simple example and does not check if a newer UPDATE_AVAILABLE status remedies the problem
    status_reports.detect do |status_report|
      Credential::UNSAFE_STATUSES.include?(status_report.status)
    end
  end
end
