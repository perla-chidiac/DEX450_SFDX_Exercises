public with sharing class CountOccurences {

    public static Map<String, Integer> Occurences (List<String> values){
        Map<String, Integer> occ = new Map<String, Integer>();

        for(String val : values){
            if(occ.containsKey(val)){
                occ.put(val, occ.get(val) + 1);
            } else {
                occ.put(val, 1);
            }
        }

        return occ;
    }
}