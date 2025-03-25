import { useRefueling } from '../hooks/useRefueling';

export const RefuelingList = () => {
  const { refuelingEntries, deleteRefueling } = useRefueling();

  return (
    <div>
      {refuelingEntries.map(entry => (
        <div key={entry.id}>
          <p>Date: {entry.date}</p>
          <p>Amount: {entry.amount} L</p>
          <p>Cost: ${entry.cost}</p>
          <p>Mileage: {entry.mileage} km</p>
          <button onClick={() => deleteRefueling(entry.id)}>Delete</button>
        </div>
      ))}
    </div>
  );
}; 