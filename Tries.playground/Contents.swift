//: Playground - noun: a place where people can play

import UIKit

class TrieNode<T: Hashable> {
    var isTerminating = false
    var value: T?
    weak var parent: TrieNode?
    var children: [T: TrieNode] = [:]
    init(value: T? = nil, parent: TrieNode? = nil) {
        self.value = value
        self.parent = parent
    }
    
    func add(child: T) {
        // 1. 确保插入的“字符”子节点在当前子节点数组中不存在
        guard children[child] == nil else { return }
        // 2. 插入
        children[child] = TrieNode(value: child, parent: self)
    }
}

class Trie {
    typealias Node = TrieNode<Character>
    fileprivate let root: Node
    init() {
        root = TrieNode<Character>()
    }
}

extension Trie {
    func insert(word: String) {
        // 如果word是个空字符串，直接返回
        guard !word.isEmpty else {
            return
        }
        // 将从根节点开始执行迭代
        var currentNode = root
        // 每个单词在Trie中都表现为一连串的字符节点
        // 例如cute：c->u->t->e
        // 因为你要一个一个地插入字符，将单词装换成一个字符数组能更方便地保留字符的插入的轨迹
        let characters = Array(word.lowercased().characters)
        var currentIndex = 0
        //TODO:
        while currentIndex < characters.count {
            // 得到当前将要插入的字符
            let character = characters[currentIndex]
            // 判断该字符是否在当前节点的“孩子们”子节点数组中是否存在
            if let child = currentNode.children[character] {
                currentNode = child // 如果存在，只需简单地将当前节点移动到这个存在的节点即可开始下一个字符的插入操作
            } else {
                // 如果不存在， 那就添加个，并移动当前节点的指针到新创建的节点上
                currentNode.add(child: character)
                currentNode = currentNode.children[character]!
            }
            currentIndex += 1
            
            // 如果currentIndex等于单词字符的数量，就说明已经到达单词的结尾，可以将结束标识置为true
            if currentIndex == characters.count {
                currentNode.isTerminating = true
            }
        }
        
    }
    
    func contains(word: String) -> Bool {
        guard !word.isEmpty else {
            return false
        }
        var currentNode = root
        let characters = Array(word.lowercased().characters)
        var currentIndex = 0
        // 这里将尝试遍历基于传递的word字符的节点
        
        // 1. 创建一个while循环， 有两个条件
        // (1). 没有到达单词的结尾
        // (2). 存在字符对应的节点
        while currentIndex < characters.count,
            let child = currentNode.children[characters[currentIndex]] {
                // 当while成功执行结束时，currentNode将会指向最终的节点， currentIndex并且是字符串的长度
                currentIndex += 1
                currentNode = child
        }
        // 成功遍历完所有的字符，并且该结束节点是某个字符串的结尾，则返回true， 否则返回false
        if currentIndex == characters.count &&
            currentNode.isTerminating {
            return true
        } else {
            return false
        }
    }
}


let trie = Trie()

trie.insert(word: "cute")
trie.contains(word: "cute") // true

trie.contains(word: "cut") // false
trie.insert(word: "cut")
trie.contains(word: "cut") // true
