/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Joseph Cloutier
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package com.player03.iterator;

import haxe.macro.Expr;
import haxe.macro.ExprTools;

#if display

class Iterators {
	/**
	 * Based on Python's range() function.
	 * 
	 * for(i in Iterators.range(len)) is equivalent to
	 * for(var i = 0; i < len; i++) in C syntax.
	 * 
	 * for(i in Iterators.range(len, 0, -1)) is equivalent to
	 * for(var i = len; i > 0; i--) in C syntax. Be careful, because this
	 * is most likely not what you want!
	 * 
	 * for(i in Iterators.range(5, 100, 2)) is equivalent to
	 * for(var i = 5; i < 100; i += 2) in C syntax.
	 * 
	 * @param	start The value to start at.
	 * @param	end The value to iterate towards. Iteration will stop
	 * just before reaching this value.
	 * @param	step The amount to increment by.
	 * @return An iterator over the integers between start and end.
	 */
	public static function range(?start:Int = 0, end:Int, ?step:Int = 1):InlineIntIterator {
		return null;
	}
	
	/**
	 * Iterates from start to end, stopping just before it reaches end.
	 * This differs from range() in that it automatically chooses whether
	 * to iterate up or down.
	 */
	public static function from(start:Int, end:Int):InlineIntIterator {
		return null;
	}
}

#else

//This file contains two implementations to allow better compile-time
//optimization. A full explanation can be found at
//http://blog.onthewings.net/2012/07/17/haxe-tips-macro-proxied-class-with-macros-for-compile-time-and-implementation-for-run-time/

#if !macro extern #end
class Iterators {
	public static macro function range(startExpr:Expr, ?endExpr:Expr, ?stepExpr:Expr = null):Expr {
		//Emulate Python's optional first argument.
		if(isNull(endExpr)) {
			endExpr = startExpr;
			startExpr = macro 0;
		}
		
		var start:Null<Int> = getInt(startExpr);
		var end:Null<Int> = getInt(endExpr);
		var step:Null<Int> = isNull(stepExpr) ? 1 : getInt(stepExpr);
		
		if(start == null || end == null || step == null) {
			return macro com.player03.iterator.Iterators_impl.range($startExpr, $endExpr, $stepExpr);
		}
		
		//Just in case someone hard-codes a step of 0.
		if(step == 0) {
			step = 1;
		}
		
		end = Iterators_impl.rangeEndValue(start, end, step);
		return macro new com.player03.iterator.InlineIntIterator($v{start}, $v{end}, $v{step});
	}
	
	public static macro function from(startExpr:Expr, endExpr:Expr):Expr {
		var start:Null<Int> = getInt(startExpr);
		var end:Null<Int> = getInt(endExpr);
		
		if(start == null || end == null) {
			return macro com.player03.iterator.Iterators_impl.from($startExpr, $endExpr);
		}
		
		var step:Int = end < start ? -1 : 1;
		
		end = Iterators_impl.rangeEndValue(start, end, step);
		return macro new com.player03.iterator.InlineIntIterator($v{start}, $v{end}, $v{step});
	}
	
	private static function isNull(expr:Expr):Bool {
		switch(expr.expr) {
			case EConst(CIdent("null")):
				return true;
			default:
				return false;
		}
	}
	
	private static function getInt(expr:Expr):Null<Int> {
		try {
			var result:Dynamic = ExprTools.getValue(expr);
			if(Std.is(result, Int)) {
				return result;
			} else {
				return null;
			}
		} catch(e:Dynamic) {
			//Unsupported expression.
			return null;
		}
	}
}

@:native("com.player03.iterator.Iterators")
@:allow(com.player03.iterator.Iterators)
class Iterators_impl {
	public static function range(start:Int, end:Int, ?step:Int = 1):InlineIntIterator {
		if(step == 0) {
			throw "Must increment by a non-zero value.";
		}
		
		end = rangeEndValue(start, end, step);
		return new InlineIntIterator(start, end, step);
	}
	
	public static function from(start:Int, end:Int):InlineIntIterator {
		return range(start, end, end < start ? -1 : 1);
	}
	
	private static function rangeEndValue(start:Int, end:Int, step:Int):Int {
		if((step > 0) == (end > start)) {
			//Subtracting 1 and rounding up ensures that it always stops
			//at the right time. If you need to edit this, make sure
			//these test cases still work:
			//Iterators.range(0, 10, 3) should produce [0, 3, 6, 9]
			//Iterators.range(0, 10, 5) should produce [0, 5]
			//Iterators.range(0, 10, 10) should produce [0]
			return Math.ceil((end - start) / step - 1) * step + start;
		} else {
			//The loop should finish immediately.
			return start - step;
		}
	}
}

#end
