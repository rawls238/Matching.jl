type Agent
  name::AbstractString
end
hash(a::Agent) = hash(a.name)
isequal(a::Agent, b::Agent) = a.name == b.name

@enum PreferenceRanking strictly_prefers = 2 weakly_prefers = 1 indifferent = 0 weakly_not_prefer = -1 strictly_not_prefer = -2

type Preferences
  a::Agent
  b::Agent
  ranking::PreferenceRanking
end

type RankedPreferences
  ranking::Dict{Agent, Vector{Agent}}
end
RankedPreferences() = RankedPreferences(Dict{Agent, Vector{Agent}}())

function add_rank!(rankings::RankedPreferences, a::Agent, b::Vector{Agent})
  rankings.ranking[a] = b
end
copy(r::RankedPreferences) = RankedPreferences(copy(r.ranking))

type Match
  results::Dict{Agent, Agent}
end

function show(io::IO, m::Match)
  s = ""
  for (key, value) in m.results
    s = s * key.name * " matches with " * value.name * "\n"
  end
  print(io, s)
end


>(a::Agent, b::Agent) = Preference(a, b, PreferenceRanking(2))
>=(a::Agent, b::Agent) = Preference(a, b, PreferenceRanking(1))
~(a::Agent, b::Agent) = Preference(a, b, PreferenceRanking(0))
<=(a::Agent, b::Agent) = Preference(a, b, PreferenceRanking(-1))
<(a::Agent, b::Agent) = Preference(a, b, PreferenceRanking(-2))


function prefers(ranking::RankedPreferences, agent::Agent, a::Agent, b::Agent)
  ranked_list = ranking.ranking[agent]
  for i in 1:length(ranked_list)
    if ranked_list[i] == a
      return true
    elseif ranked_list[i] == b
      return false
    end
  end
end
