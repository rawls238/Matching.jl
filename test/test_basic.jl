using Matching
using Base.Test

agent_a = Agent("a")
agent_b = Agent("b")
agent_c = Agent("c")
agent_1 = Agent("1")
agent_2 = Agent("2")
agent_3 = Agent("3")

rankings = RankedPreferences()
add_rank!(rankings, agent_a, [agent_2, agent_1, agent_3])
add_rank!(rankings, agent_b, [agent_3, agent_2, agent_1])
add_rank!(rankings, agent_c, [agent_1, agent_3, agent_2])

add_rank!(rankings, agent_1, [agent_b, agent_a, agent_c])
add_rank!(rankings, agent_2, [agent_c, agent_b, agent_a])
add_rank!(rankings, agent_3, [agent_a, agent_c, agent_b])

matching_1 = gale_shapley([agent_1, agent_2, agent_3], [agent_a, agent_b, agent_c], rankings)
matching_1 = matching_1.results
possible_stable_matching_1 = matching_1[agent_a] == agent_1 && matching_1[agent_b] == agent_2 && matching_1[agent_c] == agent_3
possible_stable_matching_2 = matching_1[agent_a] == agent_3 && matching_1[agent_b] == agent_1 && matching_1[agent_c] == agent_2
@test possible_stable_matching_2 || possible_stable_matching_1

# all from the proposing pool should get their first choice
matching_2 = gale_shapley([agent_a, agent_b, agent_c], [agent_1, agent_2, agent_3], rankings)
print(matching_2)
matching_2 = matching_2.results
@test matching_2[agent_2] == agent_a
@test matching_2[agent_3] == agent_b
@test matching_2[agent_1] == agent_c
