#TODO Check if pcre lib is installed using: ldconfig -p | grep libpcre3
#TODO If not. Install with apt install libpcre3-dev || yum install pcre-devel

is_pcrelib(){
    if ! command -v ldconfig &>/dev/null; then
        echo "ldconfig not found. Cannot check libpcre3. Check PATH!"
        exit 1
    fi

    if ldconfig -p | grep libpcre3 &> dev/null/; then
        echo "libpcre3 found"
        exit 0
    else
        echo "libpcre3 not found. Attempting to install..."
        
        #Try package managers (maybe update to a list file & loop for easier scalability?)
        if command -v apt &> /dev/null; then
            apt update
            apt install -y libpcre3-dev
        elif command -v yum &> /dev/null; then
            yum install -y pcre-devel
        else
            echo "Unsupported package manager. Please install Git manually."
            exit 1
        fi
    fi

    if ldconfig -p | grep libpcre3 &> dev/null/; then
        echo "libpcre3 installed successfully!"
    fi
}