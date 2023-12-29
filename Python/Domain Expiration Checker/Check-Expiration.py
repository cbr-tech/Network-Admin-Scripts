#####################################################################
#           Author: Caleb Streit                                    #
#           Date: November 22, 2023                                 #
#           Description: Check a list of domain names               #
#           for expiration dates and save to a file.                #
#####################################################################

# Import dependencies
from datetime import datetime
import csv
import os.path
import whois

# GLOBAL VARIABLES
domain_file = "domains-list.csv"
today = datetime.today().strftime('%Y-%m-%d-%H%M%S')


# The main function calls the other functions within the program
def main():
    # Open the csv file if it exists
    if os.path.isfile(domain_file):
        domain_list = read_domains_file()
    # Display error if file doesn't exist
    else:
        print(f"ERROR: The file {domain_file} does not exist.")
        exit()

    # If domains are not present in the list, display error
    if len(domain_list) <= 0:
        print(f"ERROR: No domains specified")
        exit()
    # If domains are present, begin processing list
    else:
        check_domain(domain_list)


def read_domains_file():
    with open(domain_file, 'r') as domains:
        next(domains)  # skip first row
        reader = csv.reader(domains)
        domain_list = list(reader)
        return domain_list


def check_domain(domain_list):
    # Check WHOIS information for each domain
    for pair in domain_list:

        domain = pair[0]  # domain
        company = pair[1]  # company name

        try:
            # Get the WHOIS info
            whois_expiration = whois.whois(str(domain))["expiration_date"]

            # If multiple expiration dates exist, use first one
            if isinstance(whois_expiration, list):
                whois_expiration = whois_expiration[0]

            # Export domain
            if whois_expiration is None:
                new_domain_list = [domain, company, "None"]
                export_domain(new_domain_list)
            else:
                new_domain_list = [domain, company, whois_expiration.strftime('%Y-%m-%d')]
                export_domain(new_domain_list)
        except:
            new_domain_list = [domain, company, "Error"]
            export_domain(new_domain_list)


def export_domain(new_domain_list):
    with open(f"{today} Domain Report.csv", 'a+') as newfile:
        writer = csv.writer(newfile)
        writer.writerow(new_domain_list)


if __name__ == "__main__":
    main()
