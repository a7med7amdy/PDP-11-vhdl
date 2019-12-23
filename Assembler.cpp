//#include<bits/stdc++.h>
#include<iostream>
#include<vector>
#include<string>
#include<fstream>
#include<ostream>
#include <unordered_map>
#include<bitset>
using namespace std;

vector<string>code(4096);
unordered_map<string, string>opcodes;
unordered_map<string, string>registers;
unordered_map<string, string>modes;
///////////////////////////////////////////////////////////
void assign_opcodes_reg_modes() {
	opcodes["MOV"] = "0000";
	opcodes["ADD"] = "0001";
	opcodes["ADC"] = "0010";
	opcodes["SUB"] = "0011";
	opcodes["SBC"] = "0100";
	opcodes["AND"] = "0101";
	opcodes["OR"] = "0110";
	opcodes["XNOR"] = "0111";
	opcodes["CMP"] = "1000";
	opcodes["INC"] = "1010000000";
	opcodes["DEC"] = "1010001000";
	opcodes["CLR"] = "1010010000";
	opcodes["INV"] = "1010011000";
	opcodes["LSR"] = "1010100000";
	opcodes["ROR"] = "1010101000";
	opcodes["RRC"] = "1010110000";
	opcodes["ASR"] = "1010111000";
	opcodes["LSL"] = "1011000000";
	opcodes["ROL"] = "1011001000";
	opcodes["RLC"] = "1011010000";
	opcodes["BR"] = "11000000";
	opcodes["BEQ"] = "11001000";
	opcodes["BNE"] = "11010000";
	opcodes["BLO"] = "11011000";
	opcodes["BLS"] = "11100000";
	opcodes["BHI"] = "11101000";
	opcodes["BHS"] = "11110000";
	opcodes["HLT"] = "1111100000000000";
	opcodes["NOP"] = "1111100100000000";
	opcodes["JSR"] = "1111101000000000";
	opcodes["RTS"] = "1111101100000000";
	opcodes["IRET"] = "1111110000000000";
	registers["R0"] = "000";
	registers["R1"] = "001";
	registers["R2"] = "010";
	registers["R3"] = "011";
	registers["R4"] = "100";
	registers["R5"] = "101";
	registers["R6"] = "110";
	registers["R7"] = "111";
	modes["reg"] = "00";
	modes["auto_inc"] = "01";
	modes["auto_dec"] = "10";
	modes["indexed"] = "11";
}
///////////////////////////////////////////////////////////
int k = 0;
//if there's a hash

/////////////////////////////////////////////////////////////////////////

//diagnosing branching
void find_branch(string line) {
	if (line[1] == 'E' || line[1] == 'L' || line[1] == 'N' || line[1] == 'H') {
		if ((line[2] == 'Q' || line[2] == 'E' || line[2] == 'O' || line[2] == 'S' || line[2] == 'I') && line[3] == ' ') {
			string d = ""; d += line[0]; d += line[1]; d += line[2];code[k] = opcodes[d];
			int i = 4;
			string offset = "";
			while (i < line.size()) {
				if ((line[i] - '0' >= 0 && line[i] - '0' <= 9) || line[i] == '-')
					offset += line[i++];
				else {
					cerr << "You have entered wrong input near" << endl;
					cout << "press any key to continue then enter" << endl;
					char c;
					while (cin >> c) {
						exit(0);
					}
				}
			}
			code[k] += (bitset<8>(stoi(offset)).to_string());
		}
	}
	else if (line[1] == 'R' && line[2] == ' ') {
		code[k] = opcodes["BR"];
		int i = 3;
		string offset = "";
		while (i < line.size()) {
			if((line[i]-'0'>=0&& line[i]-'0'<=9)|| line[i]=='-')
				offset += line[i++];
			else {
				cerr << "You have entered wrong input near (B)" << endl;
				cout << "press any key to continue then enter" << endl;
				char c;
				while (cin >> c) {
					exit(0);
				}
			}
		}
		code[k] += (bitset<8>(stoi(offset)).to_string());
	}
	else {
		cerr << "You have entered wrong input near (B)" << endl;
		cout << "press any key to continue then enter" << endl;
		char c;
		while (cin >> c) {
			exit(0);
		}
	}
}

/////////////////////////////////////////////////////////////////////////
string there_is_hash(string line,int indirect_flag,int hash_place) {
	int fff = line.find('(');
	if (fff >= 0) {
		if (line[fff - 1] - '0' >= 0 && line[fff - 1] - '0' <= 9 && fff < hash_place)
			indirect_flag = 1;
	}
	int start = line.find('#');
	line.erase(line.begin() + start);
	string num = "";
	while (start < line.size() && line[start] != ',') {
		if (line[start] - '0' >= 0 && line[start] - '0' <= 9) {
			num += line[start];
			line.erase(line.begin() + start);
		}
		else {
			cerr << "You have entered wrong input near" << endl;
			cout << "press any key to continue then enter" << endl;
			char c;
			while (cin >> c) {
				exit(0);
			}
		}
	}
	line.insert(start, "(R7)+");
	if (indirect_flag == 1) {
		code[k + 2] = (bitset<16>(stoi(num)).to_string());
	}
	else {
		if(code[k+1]=="")
			code[k + 1] = (bitset<16>(stoi(num)).to_string());
		else
			code[k + 2] = (bitset<16>(stoi(num)).to_string());
	}
	return line;
}
///////////////////////////////////////////////////////////////////////////////////
void process(string line) {
	//flags for indirect, direct,auto inc and dec and regester
	bool ad = 0, ai = 0, at = 0, ind = 0, dir=0;
	string check1, check2, check3 = "";
	check1 += line[0], check1 += line[1];
	check3 += line[0], check3 += line[1], check3 += line[2];
	check2 += line[0], check2 += line[1], check2 += line[2], check2 += line[3];
	bool f = 0;
	//check for the different inputs size in the code
	for (int i = 0;i < line.size();++i) {
		if (!f) {
			if (check1 == "OR") {
					code[k]+=(opcodes[check3]);
					i += 1;
			}
			else if (check2 == "XNOR" || check2 == "IRET") {
				if (check2 == "IRET") { code[k]+=(opcodes[check2]); break; }
				else {
					code[k]+=(opcodes[check2]);
					i += 3;
				}
			}
			else if (line[i] == ';')break;
			else {
				//if JSR , treat it
				code[k]+=(opcodes[check3]);
				if (check3 == "JSR") {
					string d = "";
					int o = 3;
					while (o < line.size()) {
						if(line[o]-'0'>=0 && line[o] - '0' <= 9)
							d += line[o++];
						else {
							cerr << "You have entered wrong input near" << endl;
							cout << "press any key to continue then enter" << endl;
							char c;
							while (cin >> c) {
								exit(0);
							}
						}
					}
					code[k+1]= (bitset<16>(stoi(d)).to_string());
					k += 2;
					return;
				}
				if (check3 == "HLT")break;
				i += 2;
			}
			f = 1;
		}
		else {
			if (line[i] == ';')break;
			else if (line[i] == '@')code[k]+=("1"),at=1;
			else if (line[i] == '-') { if (at != 1)code[k]+=("0"), dir = 1;code[k]+=(modes["auto_dec"]), ad = 1; }
			else if (line[i] == '+') continue;
			else if (line[i] == '(' || line[i] == ')')continue;
			else if (line[i] == 'R') {
				if (at != 1 && dir!=1)code[k] += ("0");
				if (i+3<line.size() && line[i + 3] == '+') {
					 code[k]+=(modes["auto_inc"]), ai = 1;
				}
				if (ad != 1 && ai != 1 && ind != 1)
					code[k]+=(modes["reg"]);
				string o = "";
				o += line[i],o+=line[i + 1];
				code[k]+=(registers[o]);
				i++;
			}
			else if (line[i] == ',') {
				ind = ad = ai = dir=at= 0;
			}
			else {
					if (at != 1)code[k] += ("0"), dir = 1;
					code[k] += (modes["indexed"]);
					int j = i;
					string t = "";
					while (line[j] != '(') {
						if (line[j] - '0' >= 0 && line[j] - '0' <= 9)
							t += line[j++];
						else {
							cerr << "You have entered wrong input near" << endl;
							cout << "press any key to continue then enter" << endl;
							char c;
							while (cin >> c) {
								exit(0);
							}
						}
					}
					if (code[k + 1].empty()) {
						code[k + 1] += (bitset<16>(stoi(t)).to_string());
					}
					else
						code[k + 2] += (bitset<16>(stoi(t)).to_string());
					ind = 1;
					i += t.size()-1;
			}
		}
	}
	if (code[k].size() > 16 || (code[k].size() < 16 && code[k].size() != 0)) {
		cerr << "You have entered wrong input" << endl;
		cout << "press any key to continue then enter" << endl;
		char c;
		while (cin >> c) {
			exit(0);
		}
	}
	k++;
	while (!code[k].empty()) {
		if (code[k].size() > 16 || (code[k].size() < 16 && code[k].size() != 0)) {
			cerr << "You have entered wrong input" << endl;
			cout << "press any key to continue then enter" << endl;
			char c;
			while (cin >> c) {
				exit(0);
			}
		}
		k++;
	}
}
void read_file_and_clean() {
	ifstream file("thefile.txt");
	if (file.is_open()) {
		std::string line;
		while (getline(file, line)) {
			if (line == "")
				continue;
			int hash_flag = 0;
			int indirect_flag = 0;
			int hash_place=-1;

			//diagnose branching
			///////////////////////////////////////////////////////////////////////////////////
			if (line[0] == 'B') {
				find_branch(line);
				k++;
				continue;
			}
			//////////////////////////////////////////////////////////////////////////
			//for variables at the end
			if (line[0] == '#') {
				string d = "";
				int i=1;
				while (i < line.size()) {
					d += line[i++];
				}
				code[k] += (bitset<16>(stoi(d)).to_string());
				k++;
				continue;
			}
			////////////////////////////////////////////////////////////////////////
			int num_indic = -1;
			string num = "";
			for (int i = 0;i < line.size();++i) {
				if (line[i] == ' ')
					line.erase(line.begin() + i),i--;
				//detect if there's a hash in code but not variable
				if (line[i] == '#') {
						hash_flag = 1;
						hash_place = i;
				}
				//detecting if the line has an Absolute Addressing Mode
				int comma = line.find(',');
				if (line[i] - '0' >= 0 && line[i] - '0' <= 9 && line[i-1]!='R' && ((hash_place>i || hash_place<0)||(hash_place<i && comma>hash_place && comma<i))) {
					if(num_indic<0)
						num_indic = i;
					num += line[i];
				}
				//deferentiating if the line has an Absolute Addressing Mode or the number found because line has indexed integer mainly
				if (line[i] == ','&& num_indic >= 0) {
					if (!(line[i - 1] == ')'))
						line.replace(num_indic, num.size(), num + "(R7)"), num_indic = -1,num="";
					else
						num_indic = -1;
				}
				//handling hash of immediate addressing in the operand before , (first operand)
				if (line[i] == ','&&hash_flag == 1) {
					line=there_is_hash(line, indirect_flag, hash_place);
					hash_flag = 0;
					hash_place = -1;
					i = line.find(',') ;
				}
			}
			//if there's an Absolute Addressing Modereplace it with the number and indexed by th pc
			if (num_indic >= 0 && line[line.size()-1]!=')') {
				line.replace(num_indic,num.size(),num+"(R7)");
				num_indic = -1;
			}
			string newline = line;
			//if there's a hash immediate in code  (second operand), diagnose it before processing.
			if (hash_flag == 1) {
				newline=there_is_hash(line, indirect_flag, hash_place);
			}
			process(newline);
		}
		file.close();
	}
}
///////////////////////////////////////////////////////////
void write_assembled_file() {
	//freopen_s("assembled file.txt", "W", stdout);
	ofstream outfile("assembled file.txt");
	for (int i = 0;i < code.size();++i) {
		if (i != 0) {
			if (code[i] == "") {
				outfile <<endl<< ");";
				outfile.close();
				return;
			}
			else {
				outfile << "," << endl;
			}
		}
		else {
			outfile << "SIGNAL ram : ram_type := (" << endl;
		}
		outfile <<" "<<i<<"=> \""<<code[i]<<"\"";
	}
	outfile.close();
}
////////////////////////////////////////////////////////////
int main() {
	assign_opcodes_reg_modes();
	read_file_and_clean();
	write_assembled_file();
	system("pause");
	return 0;
}