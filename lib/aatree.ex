# Generated by erl2ex (http://github.com/dazuma/erl2ex)
# From Erlang source: (Unknown source file)
# At: 2017-05-28 14:05:15
defmodule Aatree do
  @typep aatree_node() :: nil | {any(), any(), any(), any()}
  @opaque iter() :: list(aatree_node())
  @opaque aatree() :: {non_neg_integer(), aatree_node()}

  use Bitwise, only_operators: true

  defmacrop erlconst_p() do
    quote do
      2
    end
  end


  defmacrop erlmacro_pow(a, _) do
    quote do
      unquote(a) * unquote(a)
    end
  end


  defmacrop erlmacro_div2(x) do
    quote do
      unquote(x) >>> 1
    end
  end


  defmacrop erlmacro_mul2(x) do
    quote do
      unquote(x) <<< 1
    end
  end




  @spec empty() :: aatree()


  def empty() do
    {0, nil}
  end


  @spec is_empty(tree) :: boolean() when tree: aatree()


  def is_empty({0, nil}) do
    true
  end

  def is_empty(_) do
    false
  end


  @spec size(tree) :: non_neg_integer() when tree: aatree()


  def size({var_size, _}) when is_integer(var_size) and var_size >= 0 do
    var_size
  end


  @spec lookup(key, tree) :: :none | {:value, val} when key: term(), val: term(), tree: aatree()


  def lookup(key, {_, t}) do
    lookup_1(key, t)
  end


  defp lookup_1(key, {key1, _, smaller, _}) when key < key1 do
    lookup_1(key, smaller)
  end

  defp lookup_1(key, {key1, _, _, bigger}) when key > key1 do
    lookup_1(key, bigger)
  end

  defp lookup_1(_, {_, value, _, _}) do
    {:value, value}
  end

  defp lookup_1(_, nil) do
    :none
  end


  @spec is_defined(key, tree) :: boolean() when key: term(), tree: aatree()


  def is_defined(key, {_, t}) do
    is_defined_1(key, t)
  end


  defp is_defined_1(key, {key1, _, smaller, _}) when key < key1 do
    is_defined_1(key, smaller)
  end

  defp is_defined_1(key, {key1, _, _, bigger}) when key > key1 do
    is_defined_1(key, bigger)
  end

  defp is_defined_1(_, {_, _, _, _}) do
    true
  end

  defp is_defined_1(_, nil) do
    false
  end


  @spec get(tree, key) :: nil | val when key: term(), tree: aatree(), val: term()

  def get(tree, key) do
    get(tree, key, nil)
  end

  @spec get(tree, key, default) :: default | val when key: term(), tree: aatree(), val: term(), default: term()

  def get({_, t} = tree, key, default) do
    if is_defined(key, tree) do
      get_1(key, t)
    else
      default
    end
  end


  defp get_1(key, {key1, _, smaller, _}) when key < key1 do
    get_1(key, smaller)
  end

  defp get_1(key, {key1, _, _, bigger}) when key > key1 do
    get_1(key, bigger)
  end

  defp get_1(_, {_, value, _, _}) do
    value
  end

  @spec put(tree1, key, val) :: tree2 when key: term(), val: term(), tree1: aatree(), tree2: aatree()

  def put(tree, key, val) do
    if is_defined(key, tree) do
      update(key, val, tree)
    else
      insert(key, val, tree)
    end
  end

  @spec update(key, val, tree1) :: tree2 when key: term(), val: term(), tree1: aatree(), tree2: aatree()


  def update(key, val, {s, t}) do
    t1 = update_1(key, val, t)
    {s, t1}
  end


  defp update_1(key, value, {key1, v, smaller, bigger}) when key < key1 do
    {key1, v, update_1(key, value, smaller), bigger}
  end

  defp update_1(key, value, {key1, v, smaller, bigger}) when key > key1 do
    {key1, v, smaller, update_1(key, value, bigger)}
  end

  defp update_1(key, value, {_, _, smaller, bigger}) do
    {key, value, smaller, bigger}
  end


  @spec insert(key, val, tree1) :: tree2 when key: term(), val: term(), tree1: aatree(), tree2: aatree()


  def insert(key, val, {s, t}) when is_integer(s) do
    s1 = s + 1
    {s1, insert_1(key, val, t, erlmacro_pow(s1, erlconst_p()))}
  end


  defp insert_1(key, value, {key1, v, smaller, bigger}, s) when key < key1 do
    case(insert_1(key, value, smaller, erlmacro_div2(s))) do
      {t1, h1, s1} ->
        t = {key1, v, t1, bigger}
        {h2, s2} = count(bigger)
        h = erlmacro_mul2(:erlang.max(h1, h2))
        sS = s1 + s2 + 1
        p = erlmacro_pow(sS, erlconst_p())
        case(:if) do
          :if when h > p ->
            balance(t, sS)
          :if when true ->
            {t, h, sS}
        end
      t1 ->
        {key1, v, t1, bigger}
    end
  end

  defp insert_1(key, value, {key1, v, smaller, bigger}, s) when key > key1 do
    case(insert_1(key, value, bigger, erlmacro_div2(s))) do
      {t1, h1, s1} ->
        t = {key1, v, smaller, t1}
        {h2, s2} = count(smaller)
        h = erlmacro_mul2(:erlang.max(h1, h2))
        sS = s1 + s2 + 1
        p = erlmacro_pow(sS, erlconst_p())
        case(:if) do
          :if when h > p ->
            balance(t, sS)
          :if when true ->
            {t, h, sS}
        end
      t1 ->
        {key1, v, smaller, t1}
    end
  end

  defp insert_1(key, value, nil, s) when s === 0 do
    {{key, value, nil, nil}, 1, 1}
  end

  defp insert_1(key, value, nil, _s) do
    {key, value, nil, nil}
  end

  defp insert_1(key, _, _, _) do
    :erlang.error({:key_exists, key})
  end


  @spec enter(key, val, tree1) :: tree2 when key: term(), val: term(), tree1: aatree(), tree2: aatree()


  def enter(key, val, t) do
    case(is_defined(key, t)) do
      true ->
        update(key, val, t)
      false ->
        insert(key, val, t)
    end
  end


  def count({_, _, nil, nil}) do
    {1, 1}
  end

  def count({_, _, sm, bi}) do
    {h1, s1} = count(sm)
    {h2, s2} = count(bi)
    {erlmacro_mul2(:erlang.max(h1, h2)), s1 + s2 + 1}
  end

  def count(nil) do
    {1, 0}
  end


  @spec balance(tree1) :: tree2 when tree1: aatree(), tree2: aatree()


  def balance({s, t}) do
    {s, balance(t, s)}
  end


  def balance(t, s) do
    balance_list(to_list_1(t), s)
  end


  def balance_list(l, s) do
    {t, []} = balance_list_1(l, s)
    t
  end


  defp balance_list_1(l, s) when s > 1 do
    sm = s - 1
    s2 = div(sm, 2)
    s1 = sm - s2
    {t1, [{k, v} | l1]} = balance_list_1(l, s1)
    {t2, l2} = balance_list_1(l1, s2)
    t = {k, v, t1, t2}
    {t, l2}
  end

  defp balance_list_1([{key, val} | l], 1) do
    {{key, val, nil, nil}, l}
  end

  defp balance_list_1(l, 0) do
    {nil, l}
  end


  @spec from_orddict(list) :: tree when list: list({term(), term()}), tree: aatree()


  def from_orddict(l) do
    s = length(l)
    {s, balance_list(l, s)}
  end


  @spec delete_any(key, tree1) :: tree2 when key: term(), tree1: aatree(), tree2: aatree()


  def delete_any(key, t) do
    case(is_defined(key, t)) do
      true ->
        delete(key, t)
      false ->
        t
    end
  end


  @spec delete(tree1, key) :: tree2 when key: term(), tree1: aatree(), tree2: aatree()

  def delete({s, t} = tree, key) when is_integer(s) and s >= 0 do
    if is_defined(key, tree) do
      {s - 1, delete_1(key, t)}
    else
      tree
    end
  end


  defp delete_1(key, {key1, value, smaller, larger}) when key < key1 do
    smaller1 = delete_1(key, smaller)
    {key1, value, smaller1, larger}
  end

  defp delete_1(key, {key1, value, smaller, bigger}) when key > key1 do
    bigger1 = delete_1(key, bigger)
    {key1, value, smaller, bigger1}
  end

  defp delete_1(_, {_, _, smaller, larger}) do
    merge(smaller, larger)
  end


  def merge(smaller, nil) do
    smaller
  end

  def merge(nil, larger) do
    larger
  end

  def merge(smaller, larger) do
    {key, value, larger1} = take_smallest_1(larger)
    {key, value, smaller, larger1}
  end


  @spec take_smallest(tree1) :: {key, val, tree2} when tree1: aatree(), tree2: aatree(), key: term(), val: term()


  def take_smallest({var_size, tree}) when is_integer(var_size) and var_size >= 0 do
    {key, value, larger} = take_smallest_1(tree)
    {key, value, {var_size - 1, larger}}
  end


  defp take_smallest_1({key, value, nil, larger}) do
    {key, value, larger}
  end

  defp take_smallest_1({key, value, smaller, larger}) do
    {key1, value1, smaller1} = take_smallest_1(smaller)
    {key1, value1, {key, value, smaller1, larger}}
  end


  @spec smallest(tree) :: nil | {key, val} when tree: aatree(), key: term(), val: term()


  def smallest({_, t} = tree) do
    if is_empty(tree) do
      nil
    else
      smallest_1(t)
    end
  end


  defp smallest_1({key, value, nil, _larger}) do
    {key, value}
  end

  defp smallest_1({_key, _value, smaller, _larger}) do
    smallest_1(smaller)
  end


  @spec take_largest(tree1) :: {key, val, tree2} when tree1: aatree(), tree2: aatree(), key: term(), val: term()


  def take_largest({var_size, tree}) when is_integer(var_size) and var_size >= 0 do
    {key, value, smaller} = take_largest1(tree)
    {key, value, {var_size - 1, smaller}}
  end


  defp take_largest1({key, value, smaller, nil}) do
    {key, value, smaller}
  end

  defp take_largest1({key, value, smaller, larger}) do
    {key1, value1, larger1} = take_largest1(larger)
    {key1, value1, {key, value, smaller, larger1}}
  end


  @spec largest(tree) :: nil | {key, val} when tree: aatree(), key: term(), val: term()


  def largest({_, t} = tree) do
    if is_empty(tree) do
      nil
    else
      largest_1(t)
    end
  end


  defp largest_1({key, value, _smaller, nil}) do
    {key, value}
  end

  defp largest_1({_key, _value, _smaller, larger}) do
    largest_1(larger)
  end


  @spec to_list(tree) :: list({key, val}) when tree: aatree(), key: term(), val: term()


  def to_list({_, t}) do
    to_list(t, [])
  end


  defp to_list_1(t) do
    to_list(t, [])
  end


  def to_list({key, value, small, big}, l) do
    to_list(small, [{key, value} | to_list(big, l)])
  end

  def to_list(nil, l) do
    l
  end


  @spec keys(tree) :: list(key) when tree: aatree(), key: term()


  def keys({_, t}) do
    keys(t, [])
  end


  def keys({key, _value, small, big}, l) do
    keys(small, [key | keys(big, l)])
  end

  def keys(nil, l) do
    l
  end


  @spec values(tree) :: list(val) when tree: aatree(), val: term()


  def values({_, t}) do
    values(t, [])
  end


  def values({_key, value, small, big}, l) do
    values(small, [value | values(big, l)])
  end

  def values(nil, l) do
    l
  end


  @spec iterator(tree) :: iter when tree: aatree(), iter: iter()


  def iterator({_, t}) do
    iterator_1(t)
  end


  def iterator_1(t) do
    iterator(t, [])
  end


  def iterator({_, _, nil, _} = t, as) do
    [t | as]
  end

  def iterator({_, _, l, _} = t, as) do
    iterator(l, [t | as])
  end

  def iterator(nil, as) do
    as
  end


  @spec next(iter1) :: :none | {key, val, iter2} when iter1: iter(), iter2: iter(), key: term(), val: term()


  def next([{x, v, _, t} | as]) do
    {x, v, iterator(t, as)}
  end

  def next([]) do
    :none
  end


  @spec map(function, tree1) :: tree2 when function: (term(), term() -> term()), tree1: aatree(), tree2: aatree()


  def map(f, {var_size, tree}) when is_function(f, 2) do
    {var_size, map_1(f, tree)}
  end


  defp map_1(_, nil) do
    nil
  end

  defp map_1(f, {k, v, smaller, larger}) do
    {k, f.(k, v), map_1(f, smaller), map_1(f, larger)}
  end

  @spec to_string(tree) :: String.t when tree: aatree()

  def to_string({size, tree}) do
    "\n(size:" <> Integer.to_string(size) <> ")\n" <> do_to_string "", tree
  end
  def do_to_string(_, nil) do
    "\n"
  end
  def do_to_string(pref, {k, v, smaller, larger}) do
       "{ " <> Kernel.inspect(k) <> ", " <> Kernel.inspect(v) <> " }"
       <> ")\n"
    <> pref <> "+ " <> do_to_string(("  " <> pref), smaller)
    <> pref <> "+ " <> do_to_string(("  " <> pref), larger)
  end


  # def nth({_,0}, _n) do
  #   nil
  # end
  # def nth({_,size}, n) when n > size - 1 do
  #   nil
  # end
  # def nth({r,size}, n) when n < 0 do
  #   do_nth(r, size + n)
  # end
  # def nth({r,_}, n) when n >= 0 do
  #   do_nth(r, n)
  # end

  # defp do_nth({_,h,k,v,l,r}, n) do
  #   l_count = left_count(h)
  #   cond do
  #     l_count > n && l == nil -> {k,v}
  #     l_count > n -> do_nth(l, n)
  #     l_count == n -> {k,v}
  #     r == nil -> {k,v}
  #     true -> do_nth(r, n - l_count - 1)
  #   end
  # end

end
