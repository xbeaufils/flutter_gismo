package nemesys.fr.flutter_gismo;

public enum BluetoothMessage {
    STATE_CHANGE,
    DATA_CHANGE,
    READ,
    WRITE,
    ERROR;

    public static BluetoothMessage getEnum(int i ) {
        for (BluetoothMessage state : BluetoothMessage.values()) {
            if (state.ordinal() == i)
                return state;
        }
        throw new UnsupportedOperationException();
    }

}
