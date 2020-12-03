import os

from eegnb import generate_save_fn
from eegnb.devices.eeg import EEG
from eegnb.experiments.visual_n170 import n170
from eegnb.experiments.visual_p300 import p300
from eegnb.experiments.visual_ssvep import ssvep
from eegnb.experiments.auditory_ssaep import ASSR_SC # Giorgio

def intro_prompt():
    """ This function handles the user prompts for inputting information about the session they wish to record.

    """
    # define the names of the available boards
    boards = [
        'None', 'Muse2016', 'Muse2', 'MuseS', 'OpenBCI Ganglion', 'OpenBCI Cyton',
        'OpenBCI Cyton + Daisy', 'G.Tec Unicorn', 'BrainBit', 'Notion 1', 'Notion 2', 'Synthetic'
    ]

    # also define the board codes for passing to functions
    board_codes = [
        'none', 'muse2016', 'muse2', 'museS',
        'ganglion', 'cyton', 'cyton_daisy',
        'unicorn', 'brainbit', 'notion1', 'notion2', 'synthetic'
    ]

    experiments = ['visual-N170', 'visual-P300', 'visual-SSVEP', 'auditory-ASSR'] # Giorgio

    # have the user input which device they intend to record with
    print("Welcome to NeurotechX EEG Notebooks. \n"
          "Please enter the integer value corresponding to your EEG device: \n"
          f"[0] {boards[0]} \n"
          f"[1] {boards[1]} \n"
          f"[2] {boards[2]} \n"
          f"[3] {boards[3]} \n"
          f"[4] {boards[4]} \n"
          f"[5] {boards[5]} \n"
          f"[6] {boards[6]} \n"
          f"[7] {boards[7]} \n"
          f"[8] {boards[8]} \n"
          f"[9] {boards[9]} \n"
          f"[10] {boards[10]} \n",
          f"[11] {boards[11]} \n")

    board_idx = int(input('Enter Board Selection:'))
    board_selection = board_codes[board_idx]    # Board_codes are the actual names to be passed to the EEG class
    print(f"Selected board {boards[board_idx]} \n")

    # Handles wifi shield connectivity selection if an OpenBCI board is being used
    if board_selection in ['cyton', 'cyton_daisy', 'ganglion']:
        # if the ganglion is being used, will also need the MAC address
        if board_selection == 'ganglion':
            print("Please enter the Ganglions MAC address:\n")
            mac_address = input("MAC address:")

        # determine whether board is connected via Wifi or BLE
        print("Please select your connection method:\n"
              "[0] usb dongle \n"
              "[1] wifi shield \n")
        connect_idx = input("Enter connection method:")

        # add "_wifi" suffix to the end of the board name for brainflow
        if connect_idx == 1:
            board_selection = board_selection + "_wifi"

    # Experiment selection
    print("Please select which experiment you would like to run: \n"
          "[0] visual n170 \n"
          "[1] visual p300 \n"
          "[2] ssvep \n"
          "[3] ASSR \n") #Giorgio

    exp_idx = int(input('Enter Experiment Selection:'))
    exp_selection = experiments[exp_idx]
    print(f"Selected experiment {exp_selection} \n")

    # record duration
    print("Now, enter the duration of the recording (in seconds). \n")
    duration = int(input("Enter duration:"))

    # Subject ID specification
    print("Next, enter the ID# of the subject you are recording data from. \n")
    subj_id = int(input("Enter subject ID#:"))

    # Session ID specification
    print("Next, enter the session number you are recording for. \n")
    session_nb = int(input("Enter session #:"))

    # start the EEG device
    if board_selection == 'ganglion':
        # if the ganglion is chosen a MAC address should also be proviced
        eeg_device = EEG(device=board_selection, mac_addr=mac_address)
    else:
        eeg_device = EEG(device=board_selection)

    # ask if they are ready to begin
    input("Press [ENTER] when ready to begin...")

    # generate the save file name
    save_fn = generate_save_fn(board_selection, exp_selection, subj_id, session_nb)

    return eeg_device, exp_selection, duration, save_fn


def main():
    eeg_device, experiment, record_duration, save_fn = intro_prompt()

    # run experiment
    if experiment == 'visual-N170':
        n170.present(duration=record_duration, eeg=eeg_device, save_fn=save_fn)
    elif experiment == 'visual-P300':
        p300.present(duration=record_duration, eeg=eeg_device, save_fn=save_fn)
    elif experiment == 'visual-SSVEP':
        ssvep.present(duration=record_duration, eeg=eeg_device, save_fn=save_fn)
    elif experiment == 'auditory-ASSR':
        ASSR_SC.present(duration=record_duration, eeg=eeg_device, save_fn=save_fn)


if __name__=="__main__":
    main()


