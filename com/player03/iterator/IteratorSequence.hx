/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Joseph Cloutier
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

class IteratorSequence<T> {
	private var iter1:Iterator<T>;
	private var iter2:Iterator<T>;
	
	public inline function new(iter1:Iter<T>, iter2:Iter<T>) {
		this.iter1 = iter1;
		this.iter2 = iter2;
	}
	
	public inline function hasNext():Bool {
		return iter1.hasNext() || iter2.hasNext();
	}
	
	public inline function next():T {
		if(iter1.hasNext()) {
			return iter1.next();
		} else {
			return iter2.next();
		}
	}
}

abstract Iter<T>(Iterator<T>) from Iterator<T> to Iterator<T> {
	@:from private static function fromIterable<T>(iterable:Iterable<T>):Iter<T> {
		return iterable.iterator();
	}
	
	#if openfl
		@:from private static function fromVector<T>(vector:openfl.Vector<T>):Iter<T> {
			return vector.iterator();
		}
	#end
}
