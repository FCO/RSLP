use RSLP;
my &rslp = RSLP.new;
say lines.race.flatmap(*.lc.comb(/\w+/)).map({ .&rslp }).Bag
