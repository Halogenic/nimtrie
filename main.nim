import lists
import tables

type
  PTrie* = ref TTrie
  TTrie* = object of TObject
    value: string
    children: TTable[string, PTrie]

proc `$`(trie: PTrie): string =
  result = $trie[]

proc `[]`(trie: PTrie, key: string): PTrie =
  result = trie.children[key]

proc `[]=`(trie: var PTrie, key: string, val: PTrie) =
  trie.children[key] = val

proc contains(trie: PTrie, prefix: string): bool =
  if prefix.len() == 0:
    return true
  
  let head = prefix[0]
  let tail = prefix[1..prefix.len()]

  for c, child in trie.children.pairs():
    if $head == $c and child.contains(tail):
      return true

  return false

proc traverse(trie: PTrie, value=""): TDoublyLinkedList[string] =
  result = initDoublyLinkedList[string]()

  let prefix = value & trie.value

  if trie.children.len() > 0:
    for c, child in trie.children.pairs():
      for word in child.traverse(prefix):
        result.append(word)
  else:
    result.append(prefix)

proc find(trie: PTrie, prefix: string): PTrie =
  if prefix.len() == 0:
    return trie
  
  let head = prefix[0]
  let tail = prefix[1..prefix.len()]

  for c, child in trie.children.pairs():
    if $head == c:
      return child.find(tail)

  return nil

proc newTrie(value=""): PTrie =
  new result
  result.value = value
  result.children = tables.initTable[string, PTrie]()

proc trieFromArray(words: openarray[string]): PTrie =
  result = newTrie()

  var curr = result
  for word in words:
    for c in word:
      if not curr.children.hasKey($c):
        curr.children[$c] = newTrie($c)

      curr = curr[$c]

    curr = result

when isMainModule:
  var trie = trieFromArray(["like", "list", "lint"])

  echo($trie.contains("lint"))

  echo($trie.traverse())

  let node = trie.find("lik")
  if node != nil:
    echo($node)
