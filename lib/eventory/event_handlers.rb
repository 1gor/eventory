module Eventory
  class EventHandlers
    def initialize
      @event_handlers ||= {}
    end

    def add(event_class, block)
      event_handlers[event_class] ||= []
      event_handlers[event_class] << block
    end

    def for(event_class)
      event_handlers.fetch(event_class, [])
    end

    def handled_event_classes
      event_handlers.keys
    end

    private

    attr_reader :event_handlers
  end
end
