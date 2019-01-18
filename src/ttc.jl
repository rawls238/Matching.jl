using LightGraphs

function run_ttc_iteration(proposing_group::AbstractVector{Agent}, other_group::AbstractVector{Agent}, rankings::RankedPreferences)
	num_proposals = length(proposing_group)
	
	## construct a  map from nodes to agents
	other_mapping = Dict()
	proposing_mapping = Dict()
	node_to_agent_map = Dict()
	for i in 1:length(other_group)
		idx = i + num_proposals
		other_mapping[other_group[i]] = idx
		node_to_agent_map[idx] = other_group[i]
	end
    for i in 1:length(proposing_group)
    	proposing_mapping[proposing_group[i]] = i
    	node_to_agent_map[i] = proposing_group[i]
    end

    g = SimpleDiGraph(length(proposing_group) + length(other_group))
	for i in 1:length(proposing_group)
		cur_student = proposing_group[i]
		target_school = 0
    	for cur_school in rankings.ranking[cur_student]
    		if haskey(other_mapping, cur_school)
    			target_school = cur_school
    			break
    		end
    	end
    	add_edge!(g, i, other_mapping[target_school])
    end
    for i in 1:length(other_group)
    	cur_school = other_group[i]
    	target_student = 0
    	for cur_student in rankings.ranking[cur_school]
    		if haskey(proposing_mapping, cur_student)
    			target_student = cur_student
    			break
    		end
    	end
    	cur_idx = i + num_proposals
    	add_edge!(g, cur_idx, proposing_mapping[target_student])
    end

    # Find the cycles and the matches!
    matchings = Dict{Agent, Agent}()
    cycles = simplecycles(g)
    for cycle in cycles
    	for i in 1:2:length(cycle)
    		agent_1 = node_to_agent_map[cycle[i]]
    		agent_2 = node_to_agent_map[cycle[i+1]]
    		if agent_1.capacity > 0 && agent_2.capacity > 0
	    		agent_2.capacity = agent_2.capacity - 1
	    		agent_1.capacity = agent_1.capacity - 1
	    		if cycle[i] <= num_proposals
		    		matchings[agent_1] = agent_2
		    	else
		    		matchings[agent_2] = agent_1
		    	end
		    end
    	end
    end
    new_proposing_group = Vector{Agent}()
    for proposer in proposing_group
    	if proposer.capacity > 0
    		push!(new_proposing_group, proposer)
    	end
    end
    new_other_group = Vector{Agent}()
    for other in other_group
    	if other.capacity > 0
    		push!(new_other_group, other)
    	end
    end
    matchings, new_proposing_group, new_other_group
end

function ttc_with_counter(proposing_group::AbstractVector{Agent}, other_group::AbstractVector{Agent}, rankings::RankedPreferences)
	matchings = Dict{Agent, Agent}()
	while length(proposing_group) > 0
		new_matchings, proposing_group, other_group = run_ttc_iteration(proposing_group, other_group, rankings)
		merge!(matchings, new_matchings)
	end
	Match(matchings)
end