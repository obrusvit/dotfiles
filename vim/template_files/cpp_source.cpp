#include <iostream>
#include <stdexcept>
#include <vector>
using namespace std;


int main(){
    try {

        return 0;
    }
    catch(exception& e){
        cerr << e.what() << "\n";
        return 1;
    }
    catch(...){
        cerr << "something went wrong\n";
        return 2;
    }
}
