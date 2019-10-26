using Luxor

function flip_index(IC, IL, n)
   i = IC[n]
   IL[i[2], i[1]]
end

begin
   Drawing(2100, 2970, joinpath(pwd(), "scoresheet.svg"))
   background("white")
   sethue("black")

   setfont("Open Sans", 25)
   setline(1.0)

   # Meta
   begin
      translate(10, 35)

      settext("Game", O)
      line(O, O + (575, 0), :stroke)

      settext("Location", O + (575 + 25, 0))
      line(O + (575 + 25, 0), O + (575 + 25 + 575, 0), :stroke)

      settext("Date", O + (575 + 25 + 575 + 25, 0))
      line(O + (575 + 25 + 575 + 25, 0), O + (575 + 25 + 575 + 25 + 300, 0), :stroke)

      settext("Start", O + (575 + 25 + 575 + 25 + 325, 0))
      line(O + (575 + 25 + 575 + 25 + 325, 0), O + (575 + 25 + 575 + 25 + 325 + 200, 0), :stroke)

      settext("End", O + (575 + 25 + 575 + 25 + 325 + 200 + 25, 0))
      line(O + (575 + 25 + 575 + 25 + 325 + 200 + 25, 0), O + (575 + 25 + 575 + 25 + 325 + 200 + 25 + 200, 0), :stroke)

      settext("Team", O + (0, 50))
      line(O + (0, 50), O + (575, 50), :stroke)

      settext("Opponent", O + (0, 100))
      line(O + (0, 100), O + (575, 100), :stroke)

      settext("Wind", O + (575 + 25 + 575 + 25, 50))
      line(O + (575 + 25 + 575 + 25, 50), O + (575 + 25 + 575 + 25 + 300, 50), :stroke)

      settext("Temp.", O + (575 + 25 + 575 + 25 + 300 + 25, 50))
      line(O + (575 + 25 + 575 + 25 + 300 + 25, 50), O + (575 + 25 + 575 + 25 + 300 + 25 + 200, 50), :stroke)

      settext("Hum.", O + (575 + 25 + 575 + 25 + 300 + 25 + 200 + 25, 50))
      line(O + (575 + 25 + 575 + 25 + 300 + 25 + 200 + 25, 50), O + (575 + 25 + 575 + 25 + 300 + 25 + 200 + 25 + 200, 50), :stroke)

      settext("Umpires", O + (675, 100))
      settext("H", O + (675, 150))
      line(O + (675, 150), O + (675 + 300, 150), :stroke)

      settext("1B", O + (675 + 300 + 25, 150))
      line(O + (675 + 300 + 25, 150), O + (675 + 300 + 25 + 300, 150), :stroke)

      settext("2B", O + (675 + 300 + 25 + 300 + 25, 150))
      line(O + (675 + 300 + 25 + 300 + 25, 150), O + (675 + 300 + 25 + 300 + 25 + 300, 150), :stroke)

      settext("3B", O + (675 + 300 + 25 + 300 + 25 + 300 + 25, 150))
      line(O + (675 + 300 + 25 + 300 + 25 + 300 + 25, 150), O + (675 + 300 + 25 + 300 + 25 + 300 + 25 + 300, 150), :stroke)

      settext("LF", O + (675, 200))
      line(O + (675, 200), O + (675 + 300, 200), :stroke)

      settext("RF", O + (675 + 300 + 25, 200))
      line(O + (675 + 300 + 25, 200), O + (675 + 300 + 25 + 300, 200), :stroke)

      settext("R1", O + (675 + 300 + 25 + 300 + 25, 200))
      line(O + (675 + 300 + 25 + 300 + 25, 200), O + (675 + 300 + 25 + 300 + 25 + 300, 200), :stroke)

      settext("R2", O + (675 + 300 + 25 + 300 + 25 + 300 + 25, 200))
      line(O + (675 + 300 + 25 + 300 + 25 + 300 + 25, 200), O + (675 + 300 + 25 + 300 + 25 + 300 + 25 + 300, 200), :stroke)

      translate(-10, -35)
   end

   left = 10
   top = 325
   translate(left, top)

   w = 230
   h = 180
   rows = 9
   cols = 6

   w1 = 705
   rows1 = rows * 4
   cols1 = 2 + 1 + 5 + 5
   h1 = (rows * h) / rows1
   w2 = 40
   ws = [w2*1.5, w1 - (cols1 - 1 + 0.5) * w2, repeat([w2], cols1 - 2)...]
   hs = repeat([h1], rows1 + 6)

   setfont("Open Sans", 20)
   texts = ["#", "Batter", "I", "I", "P", "I", "P", "O", "AB", "BB", "K", "H", "R"]

   os = cumsum(ws) .- ws/2

   settext("Off", O + (os[3], -30), halign = "center")
   settext("Def", O + (os[6], -30), halign = "center")
   settext("Box", O + (os[11], -30), halign = "center")

   t1 = Table(hs, ws, O + (w1 / 2, (rows1 + 5) * h1 / 2))
   for (pt, i) in t1
      wi = t1.colwidths[t1.currentcol]

      if t1.currentrow % 4 === 1 && t1.currentrow <= 9*4+1
         setopacity(1.0)
         setline(1.0)
      else
         setopacity(0.5)
         setline(0.75)
      end

      # horizontal line top
      line(pt + (-wi / 2, 0), pt + (wi / 2, 0), :stroke)

      # horizontal line bottom
      if t1.currentrow == t1.nrows
         setopacity(1.0)
         setline(1.0)
         line(pt + (-wi / 2, h1), pt + (wi / 2, h1), :stroke)
      end

      if t1.currentcol ∈ [1, 3, 4, 9]
         setopacity(1.0)
         setline(1.0)
      else
         setopacity(0.5)
         setline(0.75)
      end

      # vertical line left
      line(pt + (-wi / 2, 0), pt + (-wi / 2, h1), :stroke)

      if t1.currentrow === 1
         setopacity(1.0)
         setline(1.0)
         settext(texts[t1.currentcol], pt, halign = "center")
      end

      if t1.currentrow > 9*4 && t1.currentcol === t1.ncols
         setopacity(1.0)
         setline(1.0)
         line(pt + (wi / 2, 0), pt + (wi / 2, h1), :stroke)
      end
   end

   IC = CartesianIndices((1:cols, 1:rows))
   IL = LinearIndices(CartesianIndices((1:rows, 1:cols)))

   t = Table(rows, cols, w, h, O + (w1 + (cols - 1) * w / 2, (rows - 1) * h / 2))
   for (pt, i) in t
      setline(1.0)
      setopacity(1.0)
      line(pt + (0, 0), pt + (w, 0), :stroke)
      if t1.currentrow == t1.nrows
         line(pt + (0, h), pt + (w, h), :stroke)
      end

      line(pt + (0, 0), pt + (0, h), :stroke)
      if t1.currentcol == t1.ncols
         line(pt + (w, 0), pt + (w, h), :stroke)
      end

      # plate appearence number
      settext(string(flip_index(IC, IL, i)), pt + (20,0), valign = "top", halign = "center")

      setline(0.75)
      setopacity(0.5)

      # ball / strike divider
      line(pt + (20,28), pt + (20, h), :stroke)

      # vertical divider
      line(pt + (40,0), pt + (40, h), :stroke)

      # horizontal divider
      line(pt + (40, 2/3 * h), pt + (w, 2/3 * h), :stroke)

      # diamond
      ngon(pt + (40 + (w - 40) / 2, 3/8 * h), (w-40)/5, 4, 0, :stroke)
   end

   translate(-left, -top)

   translate(10, 2215 + 45 + 180)

   w3 = w2
   h3 = h1
   r3 = 11
   c3 = 11
   hs3 = repeat([h3], r3)
   ws3 = [w3 * 1.5, ws[2], repeat([w3], c3 - 2)...]

   texts3 = ["#", "Pitcher", "L/R", "I", "O", "IP", "ER", "R", "H", "BB", "K"]

   t3 = Table(hs3, ws3, O + (sum(ws3) / 2, r3 * h3 / 2))
   for (pt, i) in t3
      wi = t3.colwidths[t3.currentcol]
      tl = pt - (wi/2, h3/2)

      # horizontal line top
      if t3.currentrow === 1
         setopacity(1.0)
         setline(1.0)
      else
         setopacity(0.5)
         setline(0.75)
      end
      line(tl, tl + (wi, 0), :stroke)

      # horizontal line bottom
      if t3.currentrow === t3.nrows
         setopacity(1.0)
         setline(1.0)
         line(tl + (0, h3), tl + (wi, h3), :stroke)
      end

      if t3.currentcol ∈ [1, 4, 6]
         setopacity(1.0)
         setline(1.0)
      else
         setopacity(0.5)
         setline(0.75)
      end

      # vertical line left
      line(tl, tl + (0, h3), :stroke)

      # vertical line right
      if t3.currentcol === t3.ncols
         setopacity(1.0)
         setline(1.0)
         line(tl + (wi, 0), tl + (wi, h3), :stroke)
      end
      if t3.currentrow === 1
         setopacity(1.0)
         settext(texts3[t3.currentcol], pt + (0, -31), halign = "center")
      end
   end

   translate(750, -h1 * 5)

   w4 = 58
   h4 = h1
   r4 = 4
   c4 = 11 * 2 + 1

   text4 = ["R", "H", "oE", "L"]

   t4 = Table(r4, c4, w4, h4, O + (c4 * w4 / 2, r4 * h4 / 2))
   for (pt, i) in t4
      wi = t4.colwidths[t4.currentcol]
      tl = pt - (wi/2, h4/2)

      # horizontal line top
      if t4.currentrow === 1
         setopacity(1.0)
         setline(1.0)
      else
         setopacity(0.5)
         setline(0.75)
      end
      line(tl, tl + (wi, 0), :stroke)

      # horizontal line bottom
      if t4.currentrow === t4.nrows
         setopacity(1.0)
         setline(1.0)
         line(tl + (0, h4), tl + (wi, h4), :stroke)
      end

      if (t4.currentcol % 2 === 0 ||t4.currentcol === 1)
         setopacity(1.0)
         setline(1.0)
      else
         setopacity(0.5)
         setline(0.75)
      end

      # vertical line left
      line(tl, tl + (0, h4), :stroke)

      # vertical line right
      if t4.currentcol === t4.ncols
         setopacity(1.0)
         setline(1.0)
         line(tl + (wi, 0), tl + (wi, h4), :stroke)
      end
      # if t4.currentrow === 1 && (t4.currentcol % 2 === 0 ||t4.currentcol === 1)
      #    setopacity(1.0)
      #    settext(string(t4.currentcol ÷ 2 + 1), pt + (0, -25), halign = "center")
      # end

      if t4.currentcol === 1
         setopacity(1.0)
         settext(text4[t4.currentrow], pt + (-50, 0), halign = "center", valign = "center")
      end
   end

   translate(0, h1 * 5)

   t5 = Table(r3, c4, w4, h3, O + (c4 * w4 / 2, r3 * h3 / 2))
   for (pt, i) in t5
      wi = t5.colwidths[t5.currentcol]
      tl = pt - (wi/2, h4/2)

      # horizontal line top
      if t5.currentrow === 1
         setopacity(1.0)
         setline(1.0)
      else
         setopacity(0.5)
         setline(0.75)
      end
      line(tl, tl + (wi, 0), :stroke)

      if t5.currentcol === 1 && t5.currentrow !== 1
         line(tl - (750 - sum(ws3), 0), tl, :stroke)
      end

      # horizontal line bottom
      if t5.currentrow === t5.nrows
         setopacity(1.0)
         setline(1.0)
         line(tl + (0, h4), tl + (wi, h4), :stroke)
      end

      if (t5.currentcol % 2 === 0 ||t5.currentcol === 1)
         setopacity(1.0)
         setline(1.0)
      else
         setopacity(0.5)
         setline(0.75)
      end

      # vertical line left
      line(tl, tl + (0, h4), :stroke)

      # vertical line right
      if t5.currentcol === t5.ncols
         setopacity(1.0)
         setline(1.0)
         line(tl + (wi, 0), tl + (wi, h4), :stroke)
      end
      if t5.currentrow === 1 && (t5.currentcol % 2 === 0 ||t5.currentcol === 1)
         setopacity(1.0)
         settext(string(t5.currentcol ÷ 2 + 1), pt + (0, -31), halign = "center")
      end
   end

   translate(-750 + sum(ws[1:end-5]), -h1 * 4)

   texts6 = texts[end-4:end]
   texts6v = ["Total"]

   t6 = Table(1, 5, w2, h1, O + (5 * w2 / 2, 1 * h1 / 2))
   for (pt, i) in t6
      wi = t6.colwidths[t6.currentcol]
      hi = t6.rowheights[t6.currentrow]
      tl = pt - (wi/2, hi/2)

      # horizontal line top
      if t6.currentrow === 1
         setopacity(1.0)
         setline(1.0)
      else
         setopacity(0.5)
         setline(0.75)
      end
      line(tl, tl + (wi, 0), :stroke)

      # horizontal line bottom
      if t6.currentrow === t6.nrows
         setopacity(1.0)
         setline(1.0)
      else
         setopacity(0.5)
         setline(0.75)
      end
      line(tl + (0, hi), tl + (wi, hi), :stroke)

      if t6.currentcol === 1
         setopacity(1.0)
         setline(1.0)
      else
         setopacity(0.5)
         setline(0.75)
      end

      # vertical line left
      line(tl, tl + (0, hi), :stroke)

      # vertical line right
      if t6.currentcol === t6.ncols
         setopacity(1.0)
         setline(1.0)
         line(tl + (wi, 0), tl + (wi, hi), :stroke)
      end
      if t6.currentrow === 1
         setopacity(1.0)
         settext(texts6[t6.currentcol], pt + (0, -45), halign = "center", valign = "center")
      end
      if t6.currentcol === 1
         setopacity(1.0)
         settext(texts6v[t6.currentrow], pt + (-50, 0), halign = "center", valign = "center")
      end
   end

   finish()
end
