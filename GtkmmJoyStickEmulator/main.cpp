#include <iostream>
#include <gtkmm.h>

using namespace std;

void on_front_button_click();
void on_back_button_click();
void on_left_button_click();
void on_right_button_click();
void on_rotate_button_click();

int main(int argv, char * args [])
{
    int argc = 0;
    char ** argcc = NULL;

    Gtk::Main kit(argc, argcc);
    Gtk::Window window;

    Gtk::Button frontButton("↑");
    Gtk::Button leftButton("←");
    Gtk::Button rightButton("→");
    Gtk::Button backButton("↓");
    Gtk::Button rotateButton("↻");

    Gtk::VBox full;
    Gtk::HBox row1;
    Gtk::HBox row2;
    Gtk::HBox row3;

    window.set_border_width(10);
    window.set_default_size(600, 600);
    window.set_size_request(600, 600);
    window.set_resizable(false);
    window.set_title("Joy Stick Emulator");
    window.set_position(Gtk::WIN_POS_CENTER);

    frontButton.signal_clicked().connect(sigc::ptr_fun(&on_front_button_click));
    backButton.signal_clicked().connect(sigc::ptr_fun(&on_back_button_click));
    leftButton.signal_clicked().connect(sigc::ptr_fun(&on_left_button_click));
    rightButton.signal_clicked().connect(sigc::ptr_fun(&on_right_button_click));
    rotateButton.signal_clicked().connect(sigc::ptr_fun(&on_rotate_button_click));

    row1.pack_start(frontButton, Gtk::PACK_EXPAND_WIDGET);
    row2.pack_start(leftButton, Gtk::PACK_EXPAND_WIDGET);
    row2.pack_start(rotateButton, Gtk::PACK_EXPAND_WIDGET);
    row2.pack_start(rightButton, Gtk::PACK_EXPAND_WIDGET);
    row3.pack_start(backButton, Gtk::PACK_EXPAND_WIDGET);

    full.pack_start(row1, Gtk::PACK_EXPAND_WIDGET);
    full.pack_start(row2, Gtk::PACK_EXPAND_WIDGET);
    full.pack_start(row3, Gtk::PACK_EXPAND_WIDGET);

    window.add(full);
    window.show_all_children();

    kit.run(window);

    return 0;
}

void on_front_button_click(){
    cout << "front" << endl;
}

void on_left_button_click(){
    cout << "left" << endl;
}

void on_right_button_click(){
    cout << "right" << endl;
}

void on_back_button_click(){
    cout << "back" << endl;
}

void on_rotate_button_click(){
    cout << "rotate" << endl;
}

// Run
// g++ main.cpp -o main `pkg-config --libs --cflags gtkmm-2.4`
