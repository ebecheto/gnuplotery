type2num(type) = \
type eq "Vacances"||type eq "off" ? 1 :\
type eq "BB130"||type eq "XTRACT" ? 2 :\
type eq "ENVISION" ||type eq "GAMHADRON" || type eq "CLARYS" || type eq "MEDICAL" ? 3 :\
type eq "DUNE" || type eq "WA105" ? 4 :\
type eq "MFT" ? 5 :\
type eq "BIOCAM" ? 6 :\
type eq "conf" || type eq "mission" || type eq "formation" ? 7 :\
type eq "CMSmuon" || type eq "CIC" ? 8 :\
9
