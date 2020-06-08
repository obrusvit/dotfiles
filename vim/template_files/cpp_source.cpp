#include <iostream>
#include <stdexcept>


int main(){
    try {
        std::cout << "Hello\n";

        return 0;
    }
    catch(std::exception& e){
        std::cerr << e.what() << "\n";
        return 1;
    }
    catch(...){
        std::cerr << "something went wrong\n";
        return 2;
    }
}
