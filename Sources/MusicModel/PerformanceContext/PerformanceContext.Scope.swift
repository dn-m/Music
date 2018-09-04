//
//  PerformanceContext.Scope.swift
//  MusicModel
//
//  Created by James Bean on 8/31/18.
//

extension PerformanceContext {

//    public struct Scope: Equatable, Hashable {
//
//        private let performer: Performer.Identifier?
//        private let instrument: Instrument.Identifier?
//        private let voice: Voice.Identifier?
//
//        /// Create a `Scope` that contains all `PerformanceContext` values.
//        public init() {
//            self.performer = nil
//            self.instrument = nil
//            self.voice = nil
//        }
//
//        /// Create a `Scope` that contains all `PerformanceContext` values with the given
//        /// `Performer.Identifier` value.
//        public init(_ performer: (Performer.Identifier)) {
//            self.performer = performer
//            self.instrument = nil
//            self.voice = nil
//        }
//
//        /// Create a `Scope` that contains all `PerformanceContext` values with the given
//        /// `Performer.Identifier` and `Instrument.Identifier` values.
//        public init(_ performer: Performer.Identifier, _ instrument: Instrument.Identifier) {
//            self.performer = performer
//            self.instrument = instrument
//            self.voice = nil
//        }
//
//        /// Create a `Scope` that contains all `PerformanceContext` values with the given
//        /// `Performer.Identifier`, `Instrument.Identifier`, and `Voice.Identifier` values.
//        public init(
//            _ performer: Performer.Identifier,
//            _ instrument: Instrument.Identifier,
//            _ voice: Voice.Identifier
//        )
//        {
//            self.performer = performer
//            self.instrument = instrument
//            self.voice = voice
//        }
//
//        /// - returns: `true` if no `performer`, `instrument`, or `voice` attributes are
//        /// specified. Also `true` if the attributes specified here match with those of the
//        /// given `context`. Otherwise, `false`.
//        public func contains(_ context: PerformanceContext.Path) -> Bool {
//            guard let performer = performer else { return true }
//            guard performer == context.performer else { return false }
//            guard let instrument = instrument else { return true }
//            guard instrument == context.instrument else { return false }
//            guard let voice = voice else { return true }
//            return voice == context.voice
//        }
//    }
}
