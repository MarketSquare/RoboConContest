from colorama import Fore, Style, init
import gspread
import json
from robot.api.logger import console

init()


class ContestUtils:

    @property
    def contest_data(self):
        contest_data = gspread.service_account().open("RoboCon 2021 Contest (Responses)").sheet1.get_all_records()
        with open("data.json", "w") as data_file:
            json.dump(contest_data, data_file, indent=2)
        return contest_data

    def get_answers(self):
        return self.contest_data

    def reveal_secret_messages(self, primary, secondary):
        console(f"\nReal Message:     {Fore.GREEN}{primary}{Style.RESET_ALL}")
        console(f"Message:   {Fore.YELLOW}{secondary}{Style.RESET_ALL}\n")

    def log_winner(self, name, email):
        console(f"{name[:16]:16} | {email[:30]:30}")
