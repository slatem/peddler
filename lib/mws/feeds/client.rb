# frozen_string_literal: true

require 'peddler/client'

module MWS
  module Feeds
    # The MWS Feeds API lets you upload inventory and order data to Amazon. You
    # can also use this API to get information about the processing of feeds.
    # @see https://sellercentral.amazon.com/gp/help/help-page.html?itemID=1611
    class Client < ::Peddler::Client
      self.version = '2009-01-01'
      self.path = "/Feeds/#{version}"

      # Uploads a feed
      #
      # @note Feed size is limited to 2,147,483,647 bytes (2^31 -1) per feed.
      # @see https://docs.developer.amazonservices.com/en_US/feeds/Feeds_SubmitFeed.html
      # @see https://docs.developer.amazonservices.com/en_US/feeds/Feeds_FeedType.html
      # @param [String] feed_content an XML or flat file feed
      # @param [String] feed_type the feed type
      # @param [Hash] opts
      # @option opts [Array<String>, String] :marketplace_id_list
      # @option opts [Boolean] :purge_and_replace
      # @return [Peddler::XMLParser]
      def submit_feed(feed_content, feed_type, opts = {})
        self.body = feed_content

        operation('SubmitFeed')
          .add(opts)
          .add('FeedType' => feed_type)
          .structure!('MarketplaceIdList', 'Id', 'ContentMD5Value', 'FeedOptions')

        run
      end

      def submit_binary_feed(feed_content, feed_type, feed_options, marketplace, opts = {})
        #self.body = feed_content
#.add("ContentMD5Value"=>md5)
        operation('SubmitFeed')
            .add('FeedContent'=>feed_content)
            .add('FeedOptions'=>feed_options)
            .add('MarketplaceIdList.Id.1'=>marketplace)
            .add('FeedType' => feed_type)
            .add(opts)
            .structure!('MarketplaceIdList', 'Id', 'FeedOptions')

        run
      end

      # Lists feed submissions
      #
      # @see https://docs.developer.amazonservices.com/en_US/feeds/Feeds_GetFeedSubmissionList.html
      # @see https://docs.developer.amazonservices.com/en_US/feeds/Feeds_FeedType.html
      # @param [Hash] opts
      # @option opts [Array<String>, String] :feed_submission_id_list
      # @option opts [Integer] :max_count
      # @option opts [Array<String>, String] :feed_type_list
      # @option opts [Array<String>, String] :feed_processing_status_list
      # @option opts [String, #iso8601] :submitted_from_date
      # @option opts [String, #iso8601] :submitted_to_date
      # @return [Peddler::XMLParser]
      def get_feed_submission_list(opts = {})
        operation('GetFeedSubmissionList')
          .add(opts)
          .structure!('FeedSubmissionIdList', 'Id')
          .structure!('FeedTypeList', 'Type')
          .structure!('FeedProcessingStatusList', 'Status')

        run
      end

      # Lists the next page of feed submissions
      #
      # @see https://docs.developer.amazonservices.com/en_US/feeds/Feeds_GetFeedSubmissionListByNextToken.html
      # @param [String] next_token
      # @return [Peddler::XMLParser]
      def get_feed_submission_list_by_next_token(next_token)
        operation('GetFeedSubmissionListByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Counts submitted feeds
      #
      # @see https://docs.developer.amazonservices.com/en_US/feeds/Feeds_GetFeedSubmissionCount.html
      # @see https://docs.developer.amazonservices.com/en_US/feeds/Feeds_FeedType.html
      # @param [Hash] opts
      # @option opts [Array<String>, String] :feed_type_list
      # @option opts [Array<String>, String] :feed_processing_status_list
      # @option opts [String, #iso8601] :submitted_from_date
      # @option opts [String, #iso8601] :submitted_to_date
      # @return [Peddler::XMLParser]
      def get_feed_submission_count(opts = {})
        operation('GetFeedSubmissionCount')
          .add(opts)
          .structure!('FeedTypeList', 'Type')
          .structure!('FeedProcessingStatusList', 'Status')

        run
      end

      # Cancels one or more feed submissions
      #
      # @see https://docs.developer.amazonservices.com/en_US/feeds/Feeds_CancelFeedSubmissions.html
      # @see https://docs.developer.amazonservices.com/en_US/feeds/Feeds_FeedType.html
      # @param [Hash] opts
      # @option opts [Array<String>, String] :feed_submission_id_list
      # @option opts [Array<String>, String] :feed_type_list
      # @option opts [String, #iso8601] :submitted_from_date
      # @option opts [String, #iso8601] :submitted_to_date
      # @return [Peddler::XMLParser]
      def cancel_feed_submissions(opts = {})
        operation('CancelFeedSubmissions')
          .add(opts)
          .structure!('FeedSubmissionIdList', 'Id')
          .structure!('FeedTypeList', 'Type')

        run
      end

      # Gets the processing report for a feed and its Content-MD5 header
      #
      # @see https://docs.developer.amazonservices.com/en_US/feeds/Feeds_GetFeedSubmissionResult.html
      # @param [Integer, String] feed_submission_id
      # @return [Peddler::XMLParser] if the report is in XML format
      # @return [Peddler::FlatFileParser] if the report is a flat file
      def get_feed_submission_result(feed_submission_id)
        operation('GetFeedSubmissionResult')
          .add('FeedSubmissionId' => feed_submission_id)

        run
      end
    end
  end
end
