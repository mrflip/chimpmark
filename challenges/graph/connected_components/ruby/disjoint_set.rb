require 'set'

# load './disjoint_set.rb' ; foo = DisjointSet.new ; foo << [1,2]
#   foo << [3,4] ; foo << [4,3] ; foo << [6,7] ; foo << [6,4] ; foo << [6,5]
#   => {5=>6, 6=>6, 1=>1, 7=>6, 2=>1, 3=>6, 4=>6}
#
class DisjointSet
  attr_accessor :roots, :items

  def initialize
    self.roots = {}
    self.items = {}
  end

  def union n1, n2
    root1 = find(n1) || make_set(n1)
    root2 = find(n2) || make_set(n2)
    if root1 != root2
      new_root, old_root = ( (items[root1].length < items[root2].length) ? [root2, root1] : [root1, root2] )
      items[old_root].each{|item| roots[item] = new_root }
      items[new_root] += items.delete(old_root)
    end
  end

  def <<(pair)
    union *pair
  end

  def make_set item
    roots[item] = item
    items[item] ||= [item].to_set
    item
  end

  def find item
    roots[item]
  end
end
