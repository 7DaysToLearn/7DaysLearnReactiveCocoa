//: Playground - noun: a place where people can play

import UIKit

var str = "7天入门精通之ReactiveCocoa"

//RAC的起源

protocol CocoaFramework {
}

protocol FP {
}

protocol RP {
}

protocol FRP:FP, RP {
}

protocol RAC:FRP, CocoaFramework {
    
}


//================================================================================

func plus1(num:Int, op:(Int) -> Int) -> Int {
    return op(num)+1
}

func x2(num:Int) -> Int {
    return num*2
}

func div2(num:Int) -> Int {
    return num/2
}

//将初始值进行指定操作后，对结果进行+1
let initInput = 1

//================================================================================

//乘以2后，对结果进行+1

//imperative programing
var a = initInput
a *= 2
a += 1

//functional programing
let b = plus1(initInput, op: x2)

//================================================================================

//原始值除2后，对结果进行+1

//imperative programing
a = initInput
a /= 2
a += 1

//funtional programing

let c = plus1(initInput, op: div2)


//================================================================================

class Signal {
    var value:Any?
    
    init(x:Int) {
        //侦听input并且将结果作为新的signal
        value = (x, 0)
    }
    
    func combine(signal:Signal) -> Signal {
        //组合信号
        //....
        return signal
    }
    
    func map(reduceOP:(Int, Int) -> Int) -> Signal {
        //映射数据流
        var a = 0
        if let tuple = value as? (Int, Int) {
            a = reduceOP(tuple.0, tuple.1)
        }
        return Signal(x:a)
    }
    
    func next(next:(Any) -> Void) {
        //有数据流到达，则发送next
        next(value)
    }
}

//实现一个计算器，输入A,B的值，自动输出A+B的结果

//imperative programing
var A = 0
var B = 0

func caculator() -> Int {
    return A+B
}

//侦听输入变化后调用caculator
NSNotificationCenter
    .defaultCenter()
    .addObserverForName(
        "InputValueDidChangeNotification",
        object: nil,
        queue: nil)
        { (noti) -> Void in
            print(caculator())
}
print(caculator())

//reactive programing

//signalC = signalA+signalB
//signalC.next {$1 in print $1 }

func signalCaculator() -> Signal {
    let signalA = Signal(x: A)
    let signalB = Signal(x: B)
    
    return signalA.combine(signalB).map { (a, b) -> Int in
        return a+b
    }
}

signalCaculator().next { (c) -> Void in
    print(c)
}

