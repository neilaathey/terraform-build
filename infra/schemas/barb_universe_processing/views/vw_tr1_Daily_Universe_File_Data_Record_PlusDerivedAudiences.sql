SELECT * --EXCEPT(padding)
    ,Audience_Category_2 - Audience_Category_3 as Audience_Category_514          	   --## Total Women  = [All Adults 16+ (203002)]- [All Adults 16+ (211001)]
    ,Audience_Category_6 - Audience_Category_14 as Audience_Category_500          	 --## Women 16-24  = [Adults 16-24  (205001)]- [Adults 16-24  (212001)]
    ,Audience_Category_7 - Audience_Category_15 as Audience_Category_501          	 --## Women 16-34  = [Adults 16-34  (206001)]- [Adults 16-34  (210001)]
    ,Audience_Category_11 - Audience_Category_19 as Audience_Category_502          	 --## Women 18-20  = [Adults 18-20  (102002)]- [Adults 18-20  (252002)]
    ,Audience_Category_12 - Audience_Category_20 as Audience_Category_503          	 --## Women 21-24  = [Adults 21-24  (102003)]- [Adults 21-24  (252003)]
    ,Audience_Category_8 - Audience_Category_16 as Audience_Category_504          	 --## Women 35-44  = [Adults 35-44  (102005)]- [Adults 35-44  (209006)]
    ,Audience_Category_13 - Audience_Category_21 as Audience_Category_505          	 --## Women 45-49  = [Adults 45-49  (251002)]- [Adults 45-49  (253001)]
    ,Audience_Category_9 - Audience_Category_17 as Audience_Category_506          	 --## Women 45-54  = [Adults 45-54  (102006)]- [Adults 45-54  (209007)]
    ,Audience_Category_10 - Audience_Category_18 as Audience_Category_507          	 --## Women 55-64  = [Adults 55-64  (102007)]- [Adults 55-64  (209008)]
    ,Audience_Category_29 - Audience_Category_32 as Audience_Category_508          	 --## Women AB  = [Adults AB  (223001)]- [Adults AB  (243001)]
    ,Audience_Category_28 - Audience_Category_31 as Audience_Category_509          	 --## Women ABC1  = [Adults ABC1  (224001)]- [Adults ABC1  (244001)]
    ,Audience_Category_34 - Audience_Category_38 as Audience_Category_510          	 --## Women ABC1 16-25 = [Adults ABC1 16-24 (254001)]- [Adults ABC1 16-24 (255001)]
    ,Audience_Category_35 - Audience_Category_39 as Audience_Category_511          	 --## Women ABC1 16-34 = [Adults ABC1 16-34 (227001)]- [Adults ABC1 16-34 (246001)]
    ,Audience_Category_36 - Audience_Category_40 as Audience_Category_512          	 --## Women ABC1 16-44 = [Adults ABC1 16-44 (228001)]- [Adults ABC1 16-44 (257001)]
    ,Audience_Category_37 - Audience_Category_41 as Audience_Category_513          	 --## Women ABC1 35-54 = [Adults ABC1 35-54 (227002)]- [Adults ABC1 35-54 (246002)]
    ,Audience_Category_44 - Audience_Category_45 as Audience_Category_515          	 --## Women working full-time = [Adults working full-time (229001)]- [Adults working full-time (213001)]
    ,Audience_Category_35 + Audience_Category_37 as Audience_Category_600          	 --## Adults 16-54  = [Adults ABC1 16-34 (227001)]+ [Adults ABC1 16-34 (227002)]

  FROM `barb_universe.Universe_Raw`
  