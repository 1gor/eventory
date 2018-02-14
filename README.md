# Eventory

A simple event store backed with Postgres.

Biggest differences when compared to Event Sourcery:

- A separate streams table to manage stream versions isn't required.
- Guaranteed gap-less event numbers (this counter table technique will/should be used in changelog projections also).
- Custom event class modelling improvements - see RecordedEvent, EventData and Event.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
