def formater(s):

    s = s.replace("\n", "")

    words =  ["የስራው መጠሪያ:", "የስራው አይነት:", "የስራው ቦታ:", "የአመልካቾች ጾታ:", "ደሞዝ/ክፍያ:", "የማመልከቻ ማብቂያ ቀን:", "የስራው ዝርዝር:" , "..."]
    wordsen= ["job_title", "job_type", "location","sex","salary","deadline","description" , "more_info"]

    final = {word: "" for word in words}

    last_index = 0
    ll = -1
    for i, word in enumerate(words):
        start = s.find(word)
        
        if start != -1:
        
            if last_index > 0:
                final[words[ll]] = s[last_index:start].strip()


            ll = i
            last_index = start + len(word)
    i = 0
    for key in words:
        final[wordsen[i]] = final.pop(key)
        i += 1
    return final




 
