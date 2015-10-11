///totro(minsyl,maxsyl,n)

/* Added for you as a nice little bonus :) */

/*
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

//From the orginal Totro doc:
// List of possible vowels, followed by list of possible consonants.
// In both lists, duplicates increase the likelihood of that selection.
// The second parameter indicates if the syllable can occur
// at the beginning, middle, or ending of a name, and is the sum of
// the following:
//  1=can be at ending,
//  2=can be at beginning
//  4=can be in middle
// Thus, the value 7 means "can be anywhere", 6 means "beginning or middle".
// 5 means "only middle or end", and 4 means "only in the middle".
// This is a binary encoding, as (middle) (beginning) (end).
// Occasionally, 'Y' will be duplicated as a vowel and a consonant.
// That's so rare that we won't worry about it, in fact it's interesting.
// There MUST be a possible vowel and possible consonant for any
// possible position; if you want to have "no vowel at the end", use
// ('',1) and make sure no other vowel includes "can be at end".

var minsyl = argument0;
var maxsyl = argument1;
var n = argument2;

var vowels,consonants, i;

/** VOWELS**/
//I HATE GameMaker's arrays...
//If you don't get this, it fills up 12 entrys of a,e,i,o and u and 
//7 in this second coloum till 80. 81 is a 4 in coloum two
for (i=0;i<80;i++) {
  if (i<12)
    vowels[i,0] = "a";
  else if (i<24)
    vowels[i,0] = "e";
  else if (i<36)
    vowels[i,0] = "i";
  else if (i<48)
    vowels[i,0] = "o";
  else if (i<60)
    vowels[i,0] = "u";
    
  vowels[i,1] = 7;
}
vowels[60,0] = "ae";
vowels[61,0] = "ai";
vowels[62,0] = "ao";
vowels[63,0] = "au";
vowels[64,0] = "aa";
vowels[65,0] = "ea";
vowels[66,0] = "eo";
vowels[67,0] = "eu";
vowels[68,0] = "ee";
vowels[69,0] = "ia";
vowels[70,0] = "io";
vowels[71,0] = "iu";
vowels[72,0] = "ii";
vowels[73,0] = "oa";
vowels[74,0] = "oe";
vowels[75,0] = "oi";
vowels[76,0] = "ou";
vowels[77,0] = "oo";
vowels[78,0] = "eau";
vowels[79,0] = "y";
vowels[80,0] = "'"; vowels[80,1] = 4;

/** CONSONANTS**/
//It doesn't get better here folks..........
consonants[0,0] = "b"; consonants[0,1] = 7;
consonants[1,0] = "c"; consonants[1,1] = 7;
consonants[2,0] = "d"; consonants[2,1] = 7;
consonants[3,0] = "f"; consonants[3,1] = 7;
consonants[4,0] = "g"; consonants[4,1] = 7;
consonants[5,0] = "h"; consonants[5,1] = 7;
consonants[6,0] = "j"; consonants[6,1] = 7;
consonants[7,0] = "k"; consonants[7,1] = 7;
consonants[8,0] = "l"; consonants[8,1] = 7;
consonants[9,0] = "m"; consonants[9,1] = 7;
consonants[10,0] = "n"; consonants[10,1] = 7;
consonants[11,0] = "p"; consonants[11,1] = 7;
consonants[12,0] = "qu"; consonants[12,1] = 6;
consonants[13,0] = "r"; consonants[13,1] = 7;
consonants[14,0] = "s"; consonants[14,1] = 7;
consonants[15,0] = "t"; consonants[15,1] = 7;
consonants[16,0] = "v"; consonants[16,1] = 7;
consonants[17,0] = "w"; consonants[17,1] = 7;
consonants[18,0] = "x"; consonants[18,1] = 7;
consonants[19,0] = "y"; consonants[19,1] = 7;
consonants[20,0] = "z"; consonants[20,1] = 7;
// Blends, sorted by second character:
consonants[22,0] = "sc"; consonants[22,1] = 7;
consonants[23,0] = "ch"; consonants[23,1] = 7;
consonants[24,0] = "gh"; consonants[24,1] = 7;
consonants[25,0] = "ph"; consonants[25,1] = 7;
consonants[26,0] = "sh"; consonants[26,1] = 7;
consonants[27,0] = "th"; consonants[27,1] = 7;
consonants[28,0] = "wh"; consonants[28,1] = 6;
consonants[29,0] = "ck"; consonants[29,1] = 5;
consonants[30,0] = "nk"; consonants[30,1] = 5;
consonants[31,0] = "rk"; consonants[31,1] = 5;
consonants[32,0] = "sk"; consonants[32,1] = 7;
consonants[33,0] = "wk"; consonants[33,1] = 0;
consonants[34,0] = "cl"; consonants[34,1] = 6;
consonants[35,0] = "fl"; consonants[35,1] = 6;
consonants[36,0] = "gl"; consonants[36,1] = 6;
consonants[37,0] = "kl"; consonants[37,1] = 6;
consonants[38,0] = "ll"; consonants[38,1] = 6;
consonants[39,0] = "pl"; consonants[39,1] = 6;
consonants[40,0] = "sl"; consonants[40,1] = 6;
consonants[41,0] = "br"; consonants[41,1] = 6;
consonants[42,0] = "cr"; consonants[42,1] = 6;
consonants[43,0] = "dr"; consonants[43,1] = 6;
consonants[44,0] = "fr"; consonants[44,1] = 6;
consonants[45,0] = "gr"; consonants[45,1] = 6;
consonants[46,0] = "kr"; consonants[46,1] = 6;
consonants[47,0] = "pr"; consonants[47,1] = 6;
consonants[48,0] = "sr"; consonants[48,1] = 6;
consonants[49,0] = "tr"; consonants[49,1] = 6;
consonants[50,0] = "ss"; consonants[50,1] = 5;
consonants[51,0] = "st"; consonants[51,1] = 7;
consonants[52,0] = "str"; consonants[52,1] = 6;
// Repeat some entries to make them more common.
consonants[53,0] = "b"; consonants[53,1] = 7;
consonants[54,0] = "c"; consonants[54,1] = 7;
consonants[55,0] = "d"; consonants[55,1] = 7;
consonants[56,0] = "f"; consonants[56,1] = 7;
consonants[57,0] = "g"; consonants[57,1] = 7;
consonants[58,0] = "h"; consonants[58,1] = 7;
consonants[59,0] = "j"; consonants[59,1] = 7;
consonants[60,0] = "k"; consonants[60,1] = 7;
consonants[61,0] = "l"; consonants[61,1] = 7;
consonants[62,0] = "m"; consonants[62,1] = 7;
consonants[63,0] = "n"; consonants[63,1] = 7;
consonants[64,0] = "p"; consonants[64,1] = 7;
consonants[65,0] = "r"; consonants[65,1] = 7;
consonants[66,0] = "s"; consonants[66,1] = 7;
consonants[67,0] = "t"; consonants[67,1] = 7;
consonants[68,0] = "v"; consonants[68,1] = 7;
consonants[69,0] = "w"; consonants[69,1] = 7;
consonants[70,0] = "b"; consonants[70,1] = 7;
consonants[71,0] = "c"; consonants[71,1] = 7;
consonants[72,0] = "d"; consonants[72,1] = 7;
consonants[73,0] = "f"; consonants[73,1] = 7;
consonants[74,0] = "g"; consonants[74,1] = 7;
consonants[75,0] = "h"; consonants[75,1] = 7;
consonants[76,0] = "j"; consonants[76,1] = 7;
consonants[77,0] = "k"; consonants[77,1] = 7;
consonants[78,0] = "l"; consonants[78,1] = 7;
consonants[79,0] = "m"; consonants[79,1] = 7;
consonants[80,0] = "n"; consonants[80,1] = 7;
consonants[81,0] = "p"; consonants[81,1] = 7;
consonants[82,0] = "r"; consonants[82,1] = 7;
consonants[83,0] = "s"; consonants[83,1] = 7;
consonants[84,0] = "t"; consonants[84,1] = 7;
consonants[85,0] = "v"; consonants[85,1] = 7;
consonants[86,0] = "w"; consonants[86,1] = 7;
consonants[87,0] = "br"; consonants[87,1] = 6;
consonants[88,0] = "dr"; consonants[88,1] = 6;
consonants[89,0] = "fr"; consonants[89,1] = 6;
consonants[90,0] = "gr"; consonants[90,1] = 6;
//I forgot 21.... :/
consonants[21,0] = "kr"; consonants[21,1] = 6;
//Have fun editing that...

// Create a random name in each for loop and add them to an array- oh no not arrays again!

var names,j;
for (j=0;j<n;j++) {
    var data_0,data_1,rnd;
    var genname = "";         // this accumulates the generated name.
    var leng = random_range(minsyl, maxsyl); // Compute number of syllables in the name
    var isvowel = irandom_range(0, 1); // randomly start with vowel or consonant
    for (i = 1; i <= leng; i++) { // syllable #. Start is 1 (not 0)
        while (true) {
            if (isvowel) {
                rnd = irandom_range(0, array_height_2d(vowels) - 1);
                data_0 = vowels[rnd,0];
                data_1 = vowels[rnd,1];
            } else {
                rnd = irandom_range(0, array_height_2d(consonants) - 1);
                data_0 = consonants[rnd,0];
                data_1 = consonants[rnd,1];
            }
            if (i == 1) { // first syllable.
                if (data_1 & 2) {
                    break;
                }
            } else if (i == leng) { // last syllable.
                if (data_1 & 1) {
                    break;
                }
            } else { // middle syllable.
                if (data_1 & 4) {
                    break;
                }
            }
        }
        genname += data_0;
        isvowel = 1 - isvowel; // Alternate between vowels and consonants.
    }
    // Initial caps:
    genname = string_upper(string_char_at(genname,1))+string_copy(genname, 2, string_length(genname)-1);
    names[j] = genname;
}
return names;
