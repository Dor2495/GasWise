import { useSelector, useDispatch } from 'react-redux';
import { RootState } from '../store/store';
import {
  addRefueling,
  removeRefueling,
  updateRefueling,
  setLoading,
  setError,
} from '../store/slices/refuelingSlice';
import type { RefuelingEntry } from '../store/slices/refuelingSlice';

export const useRefueling = () => {
  const dispatch = useDispatch();
  const refuelingState = useSelector((state: RootState) => state.refueling);

  const addNewRefueling = (entry: RefuelingEntry) => {
    dispatch(addRefueling(entry));
  };

  const deleteRefueling = (id: string) => {
    dispatch(removeRefueling(id));
  };

  const editRefueling = (entry: RefuelingEntry) => {
    dispatch(updateRefueling(entry));
  };

  return {
    refuelingEntries: refuelingState.entries,
    loading: refuelingState.loading,
    error: refuelingState.error,
    addNewRefueling,
    deleteRefueling,
    editRefueling,
  };
}; 