http://simple.wiktionary.org/wiki/Wiktionary:BNC_spoken_freq

Level 1
A different form is a different word. Capitalization is ignored.
Level 2
Regularly inflected words are part of the same family. The inflectional categories are - plural; third person singular present tense; past tense; past participle; -ing; comparative; superlative; possessive.
Level 3
-able, -er, -ish, -less, -ly, -ness, -th, -y, non-, un-, all with restricted uses.
Level 4
-al, -ation, -ess, -ful, -ism, -ist, -ity, -ize, -ment, -ous, in-, all with restricted uses.
Level 5
-age (leakage), -al (arrival), -ally (idiotically), -an (American), -ance (clearance), -ant (consultant), -ary (revolutionary), -atory (confirmatory), -dom (kingdom; officialdom), -eer (black marketeer), -en (wooden), -en (widen), -ence (emergence), -ent (absorbent), -ery (bakery; trickery), -ese (Japanese; officialese), -esque (picturesque), -ette (usherette; roomette), -hood (childhood), -i (Israeli), -ian (phonetician; Johnsonian), -ite (Paisleyite; also chemical meaning), -let (coverlet), -ling (duckling), -ly (leisurely), -most (topmost), -ory (contradictory), -ship (studentship), -ward (homeward), -ways (crossways), -wise (endwise; discussion-wise), anti- (anti-inflation), ante- (anteroom), arch- (archbishop), bi- (biplane), circum- (circumnavigate), counter- (counter-attack), en- (encage; enslave), ex- (ex-president), fore- (forename), hyper- (hyperactive), inter- (inter-African, interweave), mid- (mid-week), mis- (misfit), neo- (neo-colonialism), post- (post-date), pro- (pro-British), semi- (semi-automatic), sub- (subclassify; subterranean), un- (untie; unburden).
Level 6
-able, -ee, -ic, -ify, -ion, -ist, -ition, -ive, -th, -y, pre-, re-.


http://www.linguistics.ucsb.edu/faculty/stgries/research/dispersion/_dispersion2.r

   values[["observed overall frequency"]] <- f
   values[["sizes of corpus parts / corpus expected proportion"]] <- s
   values[["relative entropy of all sizes of the corpus parts"]] <- -sum(s*log(s))/log(length(s))

   values[["range"]] <- sum(v>0)
   values[["maxmin"]] <- max(v)-min(v)
   values[["standard deviation"]] <- sd(v)
   values[["variation coefficient"]] <- sd(v)/mean(v)
   values[["Chi-square"]] <- sum(((v-(f*s/sum(s)))^2)/(f*s/sum(s)))

   values[["Juilland et al.'s D (based on equally-sized corpus parts)"]] <- 1-((sd(v)/mean(v))/sqrt(n-1))
   values[["Juilland et al.'s D (not requiring equally-sized corpus parts)"]] <- 1-((sd(v/s)/mean(v/s))/sqrt(length(v/s)-1))
   values[["Carroll's D2"]] <- (log2(f)-(sum(v[v!=0]*log2(v[v!=0]))/f))/log2(n)
   values[["Rosengren's S (based on equally-sized corpus parts)"]] <- ((sum(sqrt(v))^2)/n)/f
   values[["Rosengren's S (not requiring equally-sized corpus parts)"]] <- sum(sqrt(v*s))^2/f
   values[["Lyne's D3 (not requiring equally-sized corpus parts)"]] <- 1-((sum(((v-mean(v))^2)/mean(v)))/(4*f))
   values[["Distributional consistency DC"]] <- ((sum(sqrt(v))/n)^2)/mean(v)
   values[["Inverse document frequency IDF"]] <- log2(n/sum(v>0))

   values[["Engvall's measure"]] <- f*(sum(v>0)/n)
   values[["Juilland et al.'s U (based on equally-sized corpus parts)"]] <- f*(1-((sd(v)/mean(v))/sqrt(n-1)))
   values[["Juilland et al.'s U (not requiring equally-sized corpus parts)"]] <- f*(1-((sd(v/s)/mean(v/s))/sqrt(length(v/s)-1)))
   values[["Carroll's Um (based on equally sized corpus parts)"]] <- f*((log2(f)-(sum(v[v!=0]*log2(v[v!=0]))/f))/log2(n))+(1-((log2(f)-(sum(v[v!=0]*log2(v[v!=0]))/f))/log2(n)))*(f/n)
   values[["Rosengren's Adjusted Frequency (based on equally sized corpus parts)"]] <- (sum(sqrt(v))^2)/n
   values[["Rosengren's Adjusted Frequency (not requiring equally sized corpus parts)"]] <- sum(sqrt(v*s))^2
   values[["Kromer's Ur"]] <- sum(digamma(v+1)+0.577215665) # C=0.577215665
