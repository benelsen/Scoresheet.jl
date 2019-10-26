using Luxor
using Printf

function ray(pt, angle, from, to, action)
   pt1 = pt + (sind(angle), -cosd(angle)) .* from
   pt2 = pt + (sind(angle), -cosd(angle)) .* to
   l = line(pt1, pt2, action)
   return pt1, pt2, l
end

ft = 12

OUTFIELD_CF = 400ft
OUTFIELD_LF = 330ft
OUTFIELD_RF = 330ft

begin
   width = (OUTFIELD_LF + OUTFIELD_RF + 2*20ft) / sqrt(2)
   height = OUTFIELD_CF + 50ft
   Drawing(width, height, joinpath(pwd(), "park.svg"))
   background("white")
   sethue("black")

   setfont("Open Sans", 80)
   setline(2.0)

   setlinecap("butt")
   setlinejoin("square")

   origin()
   translate(0, OUTFIELD_CF / 2)

   # Base Lines
   setline(5.0)
   ngonside(O - (0, 90ft/sqrt(2)), 90ft, 4, 0, :stroke)

   # Home Plate
   setline(5.0)
   sethue("white")
   rect(O - (8.5+6, 20), 2 * (8.5+6), 23, :fill)
   sethue("black")
   poly([O, O + (-8.5, -8.5), O + (-8.5, -17), O + (+8.5, -17), O + (+8.5, -8.5), O], :fill, close = true)
   # 2B
   ngonside(O - (0, sqrt(2*90^2)ft), 15, 4, 0, :fill)
   # 1B
   ngonside(O - (-(90ft - 15) / sqrt(2), (90ft) / sqrt(2)), 15, 4, 0, :fill)
   # 3B
   ngonside(O - ((90ft - 15) / sqrt(2), (90ft) / sqrt(2)), 15, 4, 0, :fill)

   # Batters Box
   setline(5.0)
   # Dirt
   arc(O, 13ft, -π/4, -3π/4, :stroke)
   # Left
   sethue("white")
   box(O + (-(2ft + 6 + 8.5), -8.5), 4ft, 6ft, :fill)
   sethue("black")
   box(O + (-(2ft + 6 + 8.5), -8.5), 4ft, 6ft, :stroke)
   # Right
   sethue("white")
   box(O + (+(2ft + 6 + 8.5), -8.5), 4ft, 6ft, :fill)
   sethue("black")
   box(O + (+(2ft + 6 + 8.5), -8.5), 4ft, 6ft, :stroke)

   # Umpire Box
   h_ump_box = 8ft - 3ft + 8.5
   pts = box(O + (0, h_ump_box/2 + 3ft - 8.5), 43, h_ump_box, vertices = true)
   poly(pts[[end-1:end..., 1:end-2...]], :stroke)

   # Pitching Mound
   circle(O - (0, 59ft), 9ft, :stroke)

   # Grass Line
   setline(5.0)
   r = 95
   b = -60.5
   α = acos((+b + sqrt(- b^2 + 2 * r^2)) / 2r)
   arc.(O - (0, 60.5ft), 95ft, (-π/2 - α), (-π/2 + α), :stroke)

   # Foul Line
   setline(5.0)
   fp_left  = O - (sind(+45), cosd(+45)) .* (330ft)
   fp_right = O - (sind(-45), cosd(-45)) .* (330ft)
   line(O + (-90ft/sqrt(2), -90ft/sqrt(2)), fp_left, :stroke)
   line(O + (+90ft/sqrt(2), -90ft/sqrt(2)), fp_right, :stroke)

   # Outfield Wall
   c, r = center3pts(fp_left, O + (0,-400ft), fp_right)
   arc2r(c, fp_left, fp_right, :stroke)

   settext(@sprintf("%.0f ft", 330), fp_left, halign = "center", angle = rad2deg(-π/2 - slope(c, fp_left)))
   settext(@sprintf("%.0f ft", 330), fp_right, halign = "center", angle = rad2deg(-π/2 - slope(c, fp_right)))
   settext(@sprintf("%.0f ft", 400), O - (0, 400).*ft, halign = "center")

   newpath()


   # Project Scoresheet / Retrosheet hit zones
   begin

      # Distance Dividers
      setline(1.0)
      rs = [25, 50, 200, 250, 300]
      arc.(O, rs.*ft, -3π/4, -π/4, :stroke)

      # 68 ft circle
      arc(O, 68ft, deg2rad(-90 - 22.5), deg2rad(-90 + 22.5), :stroke)

      # 350 ft circle
      # arc(O, 350ft, deg2rad(-90 - 22.5), deg2rad(-90 + 22.5), :stroke)
      # n_int, pt1, pt2 = intersectioncirclecircle(c, r, O, 350ft)
      n_intl, ptl1, ptl2 = intersectionlinecircle(O, polar(400ft, -π/2 - deg2rad(22.5)), O, 350ft)
      n_intr, ptr1, ptr2 = intersectionlinecircle(O, polar(400ft, -π/2 + deg2rad(22.5)), c, 350ft)
      arc2r(O, ptl1, ptr1, :stroke)

      # Radial Dividers
      begin

         # M divider
         line(O - (0, 68ft), O - (0, 200ft), :stroke)

         # Right 7L divider
         # ray(O, -(45 - 9), 50ft, 330ft, :stroke)
         n_int, pt1, pt2 = intersectionlinecircle(O, polar(100ft, -π/2 - deg2rad(45 - 9)), c, r)
         line(polar(50ft, -π/2 - deg2rad(45 - 9)), pt1, :stroke)
         d_LF_L = distance(O, pt1) / 12
         # settext(@sprintf("%.0f ft", d_LF_L), pt1, halign = "center", angle = rad2deg(-π/2 - slope(c, pt1)))

         # Left 9L divider
         # ray(O, +(45 - 9), 50ft, 330ft, :stroke)
         n_int, pt1, pt2 = intersectionlinecircle(O, polar(100ft, -π/2 + deg2rad(45 - 9)), c, r)
         line(polar(50ft, -π/2 + deg2rad(45 - 9)), pt1, :stroke)
         d_RF_R = distance(O, pt1) / 12
         # settext(@sprintf("%.0f ft", d_RF_R), pt1, halign = "center", angle = rad2deg(-π/2 - slope(c, pt1)))

         ## Left 78 divider
         # ray(O, -22.5, 25ft, 330ft, :stroke)
         n_int, pt1, pt2 = intersectionlinecircle(O, polar(100ft, -π/2 - deg2rad(22.5)), c, r)
         line(polar(25ft, -π/2 - deg2rad(22.5)), pt1, :stroke)
         d_LF_L = distance(O, pt1) / 12
         settext(@sprintf("%.0f ft", d_LF_L), pt1, halign = "center", angle = rad2deg(-π/2 - slope(c, pt1)))

         # Right 89 divider
         # ray(O, +22.5, 25ft, 330ft, :stroke)
         n_int, pt1, pt2 = intersectionlinecircle(O, polar(100ft, -π/2 + deg2rad(22.5)), c, r)
         line(polar(25ft, -π/2 + deg2rad(22.5)), pt1, :stroke)
         d_RF_R = distance(O, pt1) / 12
         settext(@sprintf("%.0f ft", d_RF_R), pt1, halign = "center", angle = rad2deg(-π/2 - slope(c, pt1)))

         ## Center Field Dividers
         # Left
         # ray(O, -9, 68ft, 330ft, :stroke)
         n_int, pt1, pt2 = intersectionlinecircle(O, polar(68ft, -π/2 - deg2rad(9)), c, r)
         line(polar(68ft, -π/2 - deg2rad(9)), pt1, :stroke)
         d_CF_L = distance(O, pt1) / 12
         # settext(@sprintf("%.0f ft", d_CF_L), pt1, halign = "center", angle = rad2deg(-π/2 - slope(c, pt1)))

         # Right
         # ray(O, +9, 68ft, 330ft, :stroke)
         n_int, pt1, pt2 = intersectionlinecircle(O, polar(68ft, -π/2 + deg2rad(9)), c, r)
         line(polar(68ft, -π/2 + deg2rad(9)), pt1, :stroke)
         d_CF_R = distance(O, pt1) / 12
         # settext(@sprintf("%.0f ft", d_CF_R), pt1, halign = "center", angle = rad2deg(-π/2 - slope(c, pt1)))
      end

      # Zone Identifieres
      begin
         settext("2",  polar(12.5ft, -π/2 + deg2rad(0)), halign = "center", valign = "center")
         settext("2F", polar(17.5ft, +π/2 + deg2rad(0)), halign = "center", valign = "center")

         settext("25F", polar(37.5ft, -π/2 + deg2rad(-45)) + (-7, +7).*ft, halign = "center", valign = "center")
         settext("25",  polar(37.5ft, -π/2 + deg2rad(-33.75)), halign = "center", valign = "center")
         settext("1S",  polar(37.5ft, -π/2 + deg2rad(0)), halign = "center", valign = "center")
         settext("23",  polar(37.5ft, -π/2 + deg2rad(+33.75)), halign = "center", valign = "center")
         settext("23F", polar(37.5ft, -π/2 + deg2rad(+45)) + (+7, +7).*ft, halign = "center", valign = "center")

         settext("5SF", polar(70ft, -π/2 + deg2rad(-45)) + (-7, +7).*ft, halign = "center", valign = "center")
         settext("5S",  polar(70ft, -π/2 + deg2rad(-45 + 9/2)), halign = "center", valign = "center")
         settext("56S", polar(70ft, -π/2 + deg2rad(-29.25)), halign = "center", valign = "center")
         settext("34S", polar(70ft, -π/2 + deg2rad(+29.25)), halign = "center", valign = "center")
         settext("3S",  polar(70ft, -π/2 + deg2rad(+45 - 9/2)), halign = "center", valign = "center")
         settext("3SF", polar(70ft, -π/2 + deg2rad(+45)) + (+7, +7).*ft, halign = "center", valign = "center")

         settext("15", polar(59ft, -π/2 + deg2rad(-15.75)), halign = "center", valign = "center")
         settext("1",  polar(59ft, -π/2 + deg2rad(0)), halign = "center", valign = "center")
         settext("13", polar(59ft, -π/2 + deg2rad(+15.75)), halign = "center", valign = "center")

         settext("6S",  polar(85ft, -π/2 + deg2rad(-15.75)), halign = "center", valign = "center")
         settext("6MS", polar(95ft, -π/2 + deg2rad(-4.5)), halign = "center", valign = "center")
         settext("4MS", polar(95ft, -π/2 + deg2rad(+4.5)), halign = "center", valign = "center")
         settext("4S",  polar(85ft, -π/2 + deg2rad(+15.75)), halign = "center", valign = "center")

         settext("5F",  polar(110ft, -π/2 + deg2rad(-45)) + (-7, +7).*ft, halign = "center", valign = "center")
         settext("5",   polar(115ft, -π/2 + deg2rad(-45 + 9/2)), halign = "center", valign = "center")
         settext("56",  polar(125ft, -π/2 + deg2rad(-29.25)), halign = "center", valign = "center")
         settext("6",   polar(130ft, -π/2 + deg2rad(-15.75)), halign = "center", valign = "center")
         settext("6M", polar(135ft, -π/2 + deg2rad(-4.5)), halign = "center", valign = "center")
         settext("4M", polar(135ft, -π/2 + deg2rad(+4.5)), halign = "center", valign = "center")
         settext("4",   polar(130ft, -π/2 + deg2rad(+15.75)), halign = "center", valign = "center")
         settext("34",  polar(125ft, -π/2 + deg2rad(+29.25)), halign = "center", valign = "center")
         settext("3",   polar(115ft, -π/2 + deg2rad(+45 - 9/2)), halign = "center", valign = "center")
         settext("3F",  polar(110ft, -π/2 + deg2rad(+45)) + (+7, +7).*ft, halign = "center", valign = "center")

         settext("5DF", polar(177.75ft, -π/2 + deg2rad(-45)) + (-7, +7).*ft, halign = "center", valign = "center")
         settext("5D",  polar(177.75ft, -π/2 + deg2rad(-45 + 9/2)), halign = "center", valign = "center")
         settext("56D", polar(177.75ft, -π/2 + deg2rad(-29.25)), halign = "center", valign = "center")
         settext("6D",  polar(177.75ft, -π/2 + deg2rad(-15.75)), halign = "center", valign = "center")
         settext("6MD", polar(177.75ft, -π/2 + deg2rad(-4.5)), halign = "center", valign = "center")
         settext("4MD", polar(177.75ft, -π/2 + deg2rad(+4.5)), halign = "center", valign = "center")
         settext("4D",  polar(177.75ft, -π/2 + deg2rad(+15.75)), halign = "center", valign = "center")
         settext("34D", polar(177.75ft, -π/2 + deg2rad(+29.25)), halign = "center", valign = "center")
         settext("3D",  polar(177.75ft, -π/2 + deg2rad(+45 - 9/2)), halign = "center", valign = "center")
         settext("3DF", polar(177.75ft, -π/2 + deg2rad(+45)) + (+7, +7).*ft, halign = "center", valign = "center")

         settext("7LSF", polar(225ft, -π/2 + deg2rad(-45)) + (-7, +7).*ft, halign = "center", valign = "center")
         settext("7LS",  polar(225ft, -π/2 + deg2rad(-45 + 9/2)), halign = "center", valign = "center")
         settext("7S",   polar(225ft, -π/2 + deg2rad(-29.25)), halign = "center", valign = "center")
         settext("78S",  polar(225ft, -π/2 + deg2rad(-15.75)), halign = "center", valign = "center")
         settext("8S",   polar(225ft, -π/2 + deg2rad(0)), halign = "center", valign = "center")
         settext("89S",  polar(225ft, -π/2 + deg2rad(+15.75)), halign = "center", valign = "center")
         settext("9S",   polar(225ft, -π/2 + deg2rad(+29.25)), halign = "center", valign = "center")
         settext("9LS",  polar(225ft, -π/2 + deg2rad(+45 - 9/2)), halign = "center", valign = "center")
         settext("9LSF", polar(225ft, -π/2 + deg2rad(+45)) + (+7, +7).*ft, halign = "center", valign = "center")

         settext("7LF", polar(275ft, -π/2 + deg2rad(-45)) + (-7, +7).*ft, halign = "center", valign = "center")
         settext("7L",  polar(275ft, -π/2 + deg2rad(-45 + 9/2)), halign = "center", valign = "center")
         settext("7",   polar(275ft, -π/2 + deg2rad(-29.25)), halign = "center", valign = "center")
         settext("78",  polar(275ft, -π/2 + deg2rad(-15.75)), halign = "center", valign = "center")
         settext("8",   polar(275ft, -π/2 + deg2rad(0)), halign = "center", valign = "center")
         settext("89",  polar(275ft, -π/2 + deg2rad(+15.75)), halign = "center", valign = "center")
         settext("9",   polar(275ft, -π/2 + deg2rad(+29.25)), halign = "center", valign = "center")
         settext("9L",  polar(275ft, -π/2 + deg2rad(+45 - 9/2)), halign = "center", valign = "center")
         settext("9LF", polar(275ft, -π/2 + deg2rad(+45)) + (+7, +7).*ft, halign = "center", valign = "center")

         settext("7LDF", polar(315ft, -π/2 + deg2rad(-45)) + (-7, +7).*ft, halign = "center", valign = "center")
         settext("7LD",  polar(320ft, -π/2 + deg2rad(-45 + 9/2)), halign = "center", valign = "center")
         settext("7D",   polar(325ft, -π/2 + deg2rad(-29.25)), halign = "center", valign = "center")
         settext("78D",  polar(325ft, -π/2 + deg2rad(-15.75)), halign = "center", valign = "center")
         settext("8D",   polar(325ft, -π/2 + deg2rad(0)), halign = "center", valign = "center")
         settext("89D",  polar(325ft, -π/2 + deg2rad(+15.75)), halign = "center", valign = "center")
         settext("9D",   polar(325ft, -π/2 + deg2rad(+29.25)), halign = "center", valign = "center")
         settext("9LD",  polar(320ft, -π/2 + deg2rad(+45 - 9/2)), halign = "center", valign = "center")
         settext("9LDF", polar(315ft, -π/2 + deg2rad(+45)) + (+7, +7).*ft, halign = "center", valign = "center")

         # settext("7XD",   polar(360ft, -π/2 + deg2rad(-29.25)), halign = "center", valign = "center")
         settext("78XD",  polar(370ft, -π/2 + deg2rad(-15.75)), halign = "center", valign = "center")
         settext("8XD",   polar(375ft, -π/2 + deg2rad(0)), halign = "center", valign = "center")
         settext("89XD",  polar(370ft, -π/2 + deg2rad(+15.75)), halign = "center", valign = "center")
         # settext("9XD",   polar(360ft, -π/2 + deg2rad(+29.25)), halign = "center", valign = "center")
      end

   end

   # Fielder Positions
   # (source https://baseballsavant.mlb.com/visuals/fielder-positioning-all?teamId=&season=2019&position=&attempts=100)
   begin
      setline(5.0)
      circle(polar(295ft, -π/2 + deg2rad(+27)), 25, :fill) # RF
      circle(polar(295ft, -π/2 + deg2rad(-27)), 25, :fill) # LF
      circle(polar(320ft, -π/2 + deg2rad(+01)), 25, :fill) # CF

      circle(polar(110ft, -π/2 + deg2rad(+34)), 25, :fill) # 1B
      circle(polar(150ft, -π/2 + deg2rad(+13)), 25, :fill) # 2B
      circle(polar(146ft, -π/2 + deg2rad(-12)), 25, :fill) # SS
      circle(polar(116ft, -π/2 + deg2rad(-30)), 25, :fill) # 3B
   end
   finish()
end
