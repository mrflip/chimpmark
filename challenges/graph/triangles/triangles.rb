
# join node_a_id on [node_id => degree] table
# join node_b_id on [node_id => degree] table

# emit [node_a, b_deg, node_b] if a_deg < b_deg
#      [node_b, a_deg, node_a] else
# group on first field
# roll up, in sort order


class MinSkewMapper
end
