defmodule AatreeTest do
  use ExUnit.Case
  doctest Aatree

  test "from_orddict" do
   tree = Aatree.from_orddict( Enum.map(1..5, &({&1,&1})) )
   IO.puts tree |> Aatree.to_string
  end

  test "new" do
    aatree = Aatree.new
    assert %Aatree{} == aatree
  end

  test "new with comparator" do
    comparator = fn(a, b) -> Aatree.compare_terms(a, b) end
    aatree = Aatree.new(comparator)
    assert %Aatree{comparator: comparator} == aatree
  end

  test "put results in ordered tree" do
    aatree = Enum.reduce([2, 1, 4, 5, 3], Aatree.new, &(Aatree.put(&2, &1, nil)))
    assert Aatree.keys(aatree) == Enum.into(1..5, [])
  end

  test "put overwrite existing keys" do
    aatree = Aatree.new
    aatree = Aatree.put(aatree, 1, :A)
    aatree = Aatree.put(aatree, 2, :B)
    assert Aatree.values(aatree) == [:A, :B]
    aatree = Aatree.put(aatree, 1, :C)
    assert Aatree.values(aatree) == [:C, :B]
  end

  test "put results in ordered tree even with ambiguous keys" do
    aatree = Aatree.new
    aatree = Aatree.put(aatree, 1, :A)
    aatree = Aatree.put(aatree, 1.0, :B)
    assert Aatree.values(aatree) == [:A, :B]
  end

  test "put overwrites existing keys with custom comparator" do
    comparator = fn
      :bigger, :smaller -> 1
      :smaller, :bigger -> -1
      a, b -> Aatree.compare_terms(a, b)
    end
    aatree = Aatree.new(comparator)
    aatree = Aatree.put(aatree, :smaller, 2)
    aatree = Aatree.put(aatree, :bigger, 1)
    aatree = Aatree.put(aatree, :bigger, 0)
    assert Aatree.keys(aatree) == [:smaller, :bigger]
  end

  test "put with custom comparator results in ordered tree" do
    assert :bigger < :smaller # funny eh?
    assert Aatree.compare_terms(:bigger, :smaller) == -1
    comparator = fn
      :bigger, :smaller -> 1
      :smaller, :bigger -> -1
      a, b -> Aatree.compare_terms(a, b)
    end
    aatree = Aatree.new(comparator)
    aatree = Aatree.put(aatree, :smaller, 2)
    aatree = Aatree.put(aatree, :bigger, 1)
    assert Aatree.keys(aatree) == [:smaller, :bigger]

    aatree = Aatree.new
    aatree = Aatree.put(aatree, :smaller, 2)
    aatree = Aatree.put(aatree, :bigger, 1)
    assert Aatree.keys(aatree) == [:bigger, :smaller]
  end

  test "get returns an item by key, or nil" do
    aatree = Enum.reduce(1..5, Aatree.new, &(Aatree.put(&2, &1, &1 * 2)))
    assert Aatree.get(aatree, 1) == 2
    assert Aatree.get(aatree, 2) == 4
    assert Aatree.get(aatree, 3) == 6
    assert Aatree.get(aatree, 4) == 8
    assert Aatree.get(aatree, 5) == 10
    assert Aatree.get(aatree, 6) ==  nil
  end

  test "count returns the number of items" do
    aatree = Enum.reduce(1..5, Aatree.new, &(Aatree.put(&2, &1, nil)))
    assert Aatree.count(aatree) == 5
  end

  test "empty? tells if a given Aatree is empty" do
    assert Aatree.empty?(Aatree.new)
  end

  test "member? tells if a given key exists" do
    aatree = Enum.reduce(1..5, Aatree.new, &(Aatree.put(&2, &1, nil)))
    assert Aatree.member?(aatree, 1)
    assert Aatree.member?(aatree, 2)
    assert Aatree.member?(aatree, 3)
    assert Aatree.member?(aatree, 4)
    assert Aatree.member?(aatree, 5)
    assert Aatree.member?(aatree, 6) == false
  end
end
