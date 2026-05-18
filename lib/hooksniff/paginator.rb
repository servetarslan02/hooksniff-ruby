# Pagination Helper for HookSniff Ruby SDK.
#
# Usage:
#   hs.message.list_all(limit: 100).each do |msg|
#     puts msg.id
#   end
#
#   # Or collect all
#   all_messages = hs.message.list_all(limit: 100).to_a

module HookSniff
  class Paginator
    include Enumerable

    def initialize(fetch_page, limit: nil)
      @fetch_page = fetch_page
      @limit = limit
    end

    def each(&block)
      return enum_for(:each) unless block_given?

      iterator = nil

      loop do
        page = @fetch_page.call(limit: @limit, iterator: iterator)

        page.data.each(&block)

        break if page.done || page.iterator.nil? || page.iterator.empty?
        iterator = page.iterator
      end
    end

    # Collect all items into an array
    def to_a
      each.to_a
    end

    # Count all items
    def count
      each.count
    end
  end
end
