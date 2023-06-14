ip_list_handler(){
    #TODO Make work yes. 1. Find last line 2. Insert new lines to conf
    #grep "^#IP LIST END "$file""
    #ed -s "$file" <<EOF
    #${line_number}i
    #${content}
    #.
    #w
    #q
    #EOF
    #TODO Find specific IPs & remove them. Make clear all function.
    #TODO Add a string comment for IPs for better usability. Delete <ip> -> delete Pertti
}