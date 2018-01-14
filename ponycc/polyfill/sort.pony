///
// This source code is copied from ponyc, and modified to suit our needs.
// The intention is to eventually create an RFC to modify it upstream.
//
// Copyright (C) 2016-2017, The Pony Developers
// Copyright (c) 2014-2015, Causality Ltd.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

interface _TransformFn[A, B]
  new val create()
  fun apply(a: A): B

primitive _IdentityFn[A] is _TransformFn[A, A]
  fun apply(a: A): A => a

type Sort[A: Comparable[A] #read] is SortBy[A, A, _IdentityFn[A]]

primitive SortBy[A: Any #alias, B: Comparable[B] #read, F: _TransformFn[A, B]]
  """
  Implementation of dual-pivot quicksort.
  """
  fun apply(seq: Seq[A]) =>
    """
    Sort the given seq.
    """
    try _sort(seq, 0, seq.size().isize() - 1)? end

  fun _sort(seq: Seq[A], lo: ISize, hi: ISize) ? =>
    if hi <= lo then return end
    // choose outermost elements as pivots
    if F(seq(lo.usize())?) > F(seq(hi.usize())?) then _swap(seq, lo, hi)? end
    (var p, var q) = (F(seq(lo.usize())?), F(seq(hi.usize())?))
    // partition according to invariant
    (var l, var g) = (lo + 1, hi - 1)
    var k = l
    while k <= g do
      if F(seq(k.usize())?) < p then
        _swap(seq, k, l)?
        l = l + 1
      elseif F(seq(k.usize())?) >= q then
        while (F(seq(g.usize())?) > q) and (k < g) do g = g - 1 end
        _swap(seq, k, g)?
        g = g - 1
        if F(seq(k.usize())?) < p then
          _swap(seq, k, l)?
          l = l + 1
        end
      end
      k = k + 1
    end
    (l, g) = (l - 1, g + 1)
    // swap pivots to final positions
    _swap(seq, lo, l)?
    _swap(seq, hi, g)?
    // recursively sort 3 partitions
    _sort(seq, lo, l - 1)?
    _sort(seq, l + 1, g - 1)?
    _sort(seq, g + 1, hi)?

  fun _swap(seq: Seq[A], i: ISize, j: ISize) ? =>
    seq(j.usize())? = seq(i.usize())? = seq(j.usize())?
