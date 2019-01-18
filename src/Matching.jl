module Matching
import Base: >=, <=, >, <, copy, show

export 
  Agent, PreferenceRanking, Preference, Agent, RankedPreferences, prefers, add_rank!,
  gale_shapley, ttc_with_counter

include("types.jl")
include("deferred_acceptance.jl")
include("ttc.jl")

end
