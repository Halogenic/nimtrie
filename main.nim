
import tables

from strutils import splitLines

type
  PTrie* = ref TTrie
  TTrie* = object of TObject
    value: string
    children: TTable[string, PTrie]

proc `$`*(trie: PTrie): string =
  result = $trie[]

proc `[]`*(trie: PTrie, key: string): PTrie =
  result = trie.children[key]

proc `[]=`*(trie: var PTrie, key: string, val: PTrie) =
  trie.children[key] = val

# does the Trie contain the given key?
proc hasKey(trie: PTrie, key: string): bool =
  result = trie.children.hasKey(key)

# does the Trie combined with its children contain the given prefix?
proc contains*(trie: PTrie, prefix: string): bool =
  if prefix.len() == 0:
    return true
  
  let head = prefix[0]
  let tail = prefix[1..prefix.len()]

  for c, child in trie.children.pairs():
    if $head == $c and child.contains(tail):
      return true

  return false

# return a list of all fully-formed words under the Trie
proc traverse*(trie: PTrie, value=""): seq[string] =
  result = @[]

  let prefix = value & trie.value

  if trie.children.len() > 0:
    for c, child in trie.children.pairs():
      for word in child.traverse(prefix):
        result = result & word
  else:
    result = result & prefix

# find the node associated with the given prefix or nil if none
proc find*(trie: PTrie, prefix: string): PTrie =
  if prefix.len() == 0:
    return trie
  
  let head = prefix[0]
  let tail = prefix[1..prefix.len()]

  for c, child in trie.children.pairs():
    if $head == c:
      return child.find(tail)

  return nil

# create a new ref to a TTrie
proc newTrie*(value=""): PTrie =
  new result
  result.value = value
  result.children = tables.initTable[string, PTrie]()

# create a new ref to a TTrie from an array of words
proc trieFromArray*(words: openarray[string]): PTrie =
  result = newTrie()

  var curr = result
  for word in words:
    for c in word:
      if not curr.hasKey($c):
        curr.children[$c] = newTrie($c)

      curr = curr[$c]

    curr = result

when isMainModule:
  let words = "/usr/share/dict/words".readFile().splitLines()

  let trie = trieFromArray(words)

  echo($trie.contains("lint"))
