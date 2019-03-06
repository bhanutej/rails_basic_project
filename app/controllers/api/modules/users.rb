# Api
module Api
  # Modules
  module Modules
    # Users
    module Users
      extend ActiveSupport::Concern

      def create_user_otp(user)
        otp_code = ROTP::TOTP.new(user.otp_secret_key, issuer: 'Smart Notification').now
        user_otp = user.user_otps.create(otp_value: otp_code, is_validated: false, expiry_date: Time.now.utc + 7200)
        # send_otp_code(user.phone_number, otp_code)
        logger.debug ">>>OTP>>>#{user_otp.otp_value}"
        render json: { message: 'OTP sent successfully!', otp: user_otp.otp_value }, status: t('status.ok')
      end

      def send_otp_code(phone_number, otp_code)
        sms_gatway = SmsGatway.new(phone_number, "mobile number verfication OTP: #{otp_code}")
        sms_gatway.send_otp
      end
    end
  end
end
