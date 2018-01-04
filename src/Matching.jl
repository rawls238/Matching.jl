module Matching
import Base: >=, <=, >, <, copy, show

export 
  Agent, PreferenceRanking, Preference, Agent, RankedPreferences, prefers, add_rank!,
  gale_shapley

include("types.jl")
include("deferred_acceptance.jl")

end
