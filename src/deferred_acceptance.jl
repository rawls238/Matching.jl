
function gale_shapley(proposing_group::AbstractVector{Agent}, other_group::AbstractVector{Agent}, rankings::RankedPreferences)
  rankings = copy(rankings)
  free_proposing_group = Dict{Agent, Bool}()
  matchings = Dict{Agent, Agent}() #keys correspond to agents in the other group!
  for i in 1:length(proposing_group)
    free_proposing_group[proposing_group[i]] = true
  end

  while length(free_proposing_group) > 0
    proposing_man = first(free_proposing_group)[1]
    first_woman = rankings.ranking[proposing_man][1]
    if haskey(matchings, first_woman)
      current_match = matchings[first_woman]
      if prefers(rankings, first_woman, proposing_man, current_match)
        matchings[first_woman] = proposing_man
        free_proposing_group[current_match] = true
        delete!(free_proposing_group, proposing_man)
      end
    else
      matchings[first_woman] = proposing_man
      delete!(free_proposing_group, proposing_man)
    end
    deleteat!(rankings.ranking[proposing_man], 1)
  end
  Match(matchings)
end



# group_1 is the proposing group
function extended_gale_shapley(proposing_group::AbstractVector{Agent}, other_group::AbstractVector{Agent})
  proposing_group = copy(proposing_group)
  other_group = copy(other_group)
  free_proposing_group = Dict{Agent, Bool}()
  free_other_group = Dict{Agent, Bool}()
  matchings = Dict{Agent, Agent}() #keys are from the other group!
  for i in 1:length(proposing_group)
    free_proposing_group[proposing_group[i]] = true
    free_other_group[other_group[i]] = true
    for j in 1:length(proposing_group)
      matchings[proposing_group[i]] = other_group[j]
    end
  end
  
  matchings_2 = Dict{Agent, Agent}()
  while length(free_proposing_group) > 0
    proposing_man = first(free_proposing_group)[1]
    first_woman = proposing_man.ranked_list[1]
    if haskey(matchings, first_woman)
      delete!(matchings, first_woman)
    end
    matchings[first_woman] = proposing_man
    first_woman
  end

end
