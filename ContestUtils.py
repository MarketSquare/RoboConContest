import gspread
import json
from robot.api.logger import console


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
        console(f"\nReal Message: {primary}")
        console(f"Message:      {secondary}\n")

    def log_winner(self, name, email):
        console(f"{name[:30]:30} | {email[:48]:48}")
