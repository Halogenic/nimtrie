import tables

type
  PTrie* = ref TTrie
  TTrie* = object of TObject
    value*: string
    children*: TTable[string, PTrie]

proc `$`(trie: PTrie): string =
  result = $trie[]

proc `[]`(trie: PTrie, key: string): PTrie =
  result = trie.children[key]

proc `[]=`(trie: var PTrie, key: string, val: PTrie) =
  trie.children[key] = val

#proc contains(trie: PTrie, prefix: string): bool =
#  if not prefix:
#    return true
#  
#  head = prefix[0]
#  tail = prefix[1..]
#
#  for c, child in trie.children.pairs():
#    echo($c)

proc newTrie(value=""): PTrie =
  new result
  result.value = value
  result.children = tables.initTable[string, PTrie]()

when isMainModule:
  var trie = newTrie()

  trie["a"] = newTrie("a")

  let t = trie["a"]
  echo($trie)
  echo($t)
