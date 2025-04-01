import { useState } from 'react';
import { useRefueling } from '../hooks/useRefueling';

export const RefuelingForm = () => {
  const { addNewRefueling } = useRefueling();
  const [formData, setFormData] = useState({
    date: '',
    amount: '',
    cost: '',
    mileage: '',
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    addNewRefueling({
      id: Date.now().toString(),
      date: formData.date,
      amount: Number(formData.amount),
      cost: Number(formData.cost),
      mileage: Number(formData.mileage),
    });
    // Reset form
    setFormData({ date: '', amount: '', cost: '', mileage: '' });
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* Your form fields here */}
    </form>
  );
}; 